package de.bitb.main_service.datasource.firestore

import com.google.api.core.ApiFuture
import com.google.cloud.firestore.*
import org.slf4j.Logger
import java.util.concurrent.ExecutionException

abstract class FirestoreApi<T : Any> {
    abstract val log: Logger
    abstract val firestore: Firestore

    abstract fun getDocumentPath(obj: T): String

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> getDocument(
        collectionPath: String,
        whereCondition: (CollectionReference) -> Query = { it },
    ): T? {
        return try {
            val apiFuture: ApiFuture<QuerySnapshot> =
                whereCondition(firestore.collection(collectionPath)).get()
            val documentSnapshot: DocumentSnapshot = apiFuture.get().documents.first()
            documentSnapshot.toObject(T::class.java)
        } catch (e: Exception) {
            log.error("getDocument; path: $collectionPath  error: ${e.message}")
            null
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> findDocumentInCollection(
        collectionName: String,
        whereCondition: (CollectionGroup) -> Query = { it },
    ): T? {
        return try {
            val apiFuture: ApiFuture<QuerySnapshot> =
                whereCondition(firestore.collectionGroup(collectionName)).get()
            val documentSnapshot: DocumentSnapshot = apiFuture.get().documents.first()
            documentSnapshot.toObject(T::class.java)
        } catch (e: Exception) {
            log.error("findDocumentInCollection; collectionName: $collectionName  error: ${e.message}")
            null
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> getCollection(
        collectionPath: String,
        whereCondition: (CollectionReference) -> Query = { it },
    ): List<T> {
        var path = ""
        return try {
            path = collectionPath
            val apiFuture: ApiFuture<QuerySnapshot> =
                whereCondition(firestore.collection(path)).get()
            val documentsSnapshot: List<DocumentSnapshot> = apiFuture.get().documents
            documentsSnapshot.map { it.toObject(T::class.java)!! }
        } catch (e: Exception) {
            log.error("getCollection; path: $path  error: ${e.message}")
            emptyList()
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun writeDocument(obj: T) {
        var path = "PATH ERROR"
        try {
            path = getDocumentPath(obj)
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
            path = getDocumentPath(obj)
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
            path = getDocumentPath(obj)
            val apiFuture: ApiFuture<WriteResult> = firestore.document(path).delete()
            apiFuture.get()
        } catch (e: Exception) {
            log.error("deleteDocument; path: $path  error: ${e.message}")
        }
    }
}