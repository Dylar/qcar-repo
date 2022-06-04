package de.bitb.main_service.datasource

import com.google.api.core.ApiFuture
import com.google.cloud.firestore.DocumentSnapshot
import com.google.cloud.firestore.Firestore
import com.google.cloud.firestore.WriteResult
import de.bitb.main_service.controller.API_VERSION_V1
import org.slf4j.Logger
import java.util.concurrent.ExecutionException

abstract class FirestoreApi<T : Any> {
    abstract val log: Logger
    abstract val firestore: Firestore

    abstract fun getDocumentPath(obj: T): String

    fun addVersion(path: String) = "$API_VERSION_V1/$path"

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> readDocument(objPath: String): T? {
        return try {
            val path = addVersion(objPath)
            log.info("readDocument: $path")
            // you could reference document by this.firestore.collection("collectionName").document("objName") as well
//            val docPath = getDocumentPath(path)
            val apiFuture: ApiFuture<DocumentSnapshot> =
                this.firestore.document(path).get()
            val documentSnapshot: DocumentSnapshot = apiFuture.get()
            documentSnapshot.toObject(T::class.java)
        } catch (e: Exception) {
            log.error(e.message)
            null
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun writeDocument(obj: T) {
        try {
            val path = addVersion(getDocumentPath(obj))
            log.info("writeDocument: $path")
            val apiFuture: ApiFuture<WriteResult> = firestore.document(path).set(obj)
            val writeResult: WriteResult = apiFuture.get()
            log.info("Update time: {}", writeResult.updateTime)
        } catch (e: Exception) {
            log.error(e.message)
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun updateDocument(obj: T) {
        try {
            val path = addVersion(getDocumentPath(obj))
            log.info("updateDocument: $path")
            val apiFuture: ApiFuture<WriteResult> = this.firestore.document(path)
                .set(obj)
            val writeResult: WriteResult = apiFuture.get()
            log.info("Update time: {}", writeResult.updateTime)
        } catch (e: Exception) {
            log.error(e.message)
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun deleteDocument(obj: T) {
        try {
            // document deletion does not delete its sub collections
            // see https://firebase.google.com/docs/firestore/manage-data/delete-data#collections
            val path = addVersion(getDocumentPath(obj))
            log.info("deleteDocument: $path")
            val apiFuture: ApiFuture<WriteResult> = this.firestore.document(path).delete()
            val writeResult: WriteResult = apiFuture.get()
            log.info("Update time: {}", writeResult.updateTime)
        } catch (e: Exception) {
            log.error(e.message)
        }
    }
}