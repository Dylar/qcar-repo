package de.bitb.main_service.datasource

import com.google.api.core.ApiFuture
import com.google.cloud.firestore.*
import de.bitb.main_service.controller.API_VERSION_V1
import org.slf4j.Logger
import java.util.concurrent.ExecutionException

abstract class FirestoreApi<T : Any> {
    abstract val log: Logger
    abstract val firestore: Firestore

    abstract fun getDocumentPath(obj: T): String

    fun addVersion(path: String) = "$API_VERSION_V1/$path"

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> readDocument(
        collectionPath: String,
        whereCondition: (CollectionReference) -> Query,
    ): T? {
        var path = ""
        return try {
            path = addVersion(collectionPath)
            val apiFuture: ApiFuture<QuerySnapshot> =
                whereCondition(firestore.collection(path)).get()
            val documentSnapshot: DocumentSnapshot = apiFuture.get().documents.first()
            documentSnapshot.toObject(T::class.java)
        } catch (e: Exception) {
            log.error("readDocument; path: $path  error: ${e.message}")
            null
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> findDocument(
        collectionId: String,
        whereCondition: (CollectionGroup) -> Query,
    ): T? {
        return try {
            val apiFuture: ApiFuture<QuerySnapshot> =
                whereCondition(firestore.collectionGroup(collectionId)).get()
            val documentSnapshot: DocumentSnapshot = apiFuture.get().documents.first()
            documentSnapshot.toObject(T::class.java)
        } catch (e: Exception) {
            log.error("findDocument; collectionId: $collectionId  error: ${e.message}")
            null
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun writeDocument(obj: T) {
        var path = "PATH ERROR"
        try {
            path = addVersion(getDocumentPath(obj))
            val apiFuture: ApiFuture<WriteResult> = firestore.document(path).set(obj)
            apiFuture.get()
        } catch (e: Exception) {
            log.error("writeDocument; path: $path  error: ${e.message}")
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun updateDocument(obj: T) {
        var path = "PATH ERROR"
        try {
            path = addVersion(getDocumentPath(obj))
            log.info("updateDocument: $path")
            val apiFuture: ApiFuture<WriteResult> = firestore.document(path)
                .set(obj)
            apiFuture.get()
        } catch (e: Exception) {
            log.error("updateDocument; path: $path  error: ${e.message}")
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun deleteDocument(obj: T) {
        var path = ""
        try {
            // document deletion does not delete its sub collections
            // see https://firebase.google.com/docs/firestore/manage-data/delete-data#collections
            path = addVersion(getDocumentPath(obj))
            val apiFuture: ApiFuture<WriteResult> = firestore.document(path).delete()
            apiFuture.get()
        } catch (e: Exception) {
            log.error("deleteDocument; path: $path  error: ${e.message}")
        }
    }
}