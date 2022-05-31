package de.bitb.main_service.datasource

import com.google.api.core.ApiFuture
import com.google.cloud.firestore.DocumentSnapshot
import com.google.cloud.firestore.Firestore
import com.google.cloud.firestore.WriteResult
import org.slf4j.Logger
import java.util.concurrent.ExecutionException

abstract class FirestoreApi<T : Any> {
    abstract val log: Logger
    abstract val firestore: Firestore

    abstract fun getDocumentPath(obj: T): String

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> readDocument(path: String): T? {
        return try {
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
            val docPath = getDocumentPath(obj)
            log.info("writeDocument: $docPath")
            val apiFuture: ApiFuture<WriteResult> = firestore.document(docPath).set(obj)
            val writeResult: WriteResult = apiFuture.get()
            log.info("Update time: {}", writeResult.updateTime)
        } catch (e: Exception) {
            log.error(e.message)
        }
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun updateDocument(obj: T) {
        try {
            val docPath = getDocumentPath(obj)
            log.info("updateDocument: $docPath")
            val apiFuture: ApiFuture<WriteResult> = this.firestore.document(docPath)
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
            val docPath = getDocumentPath(obj)
            log.info("deleteDocument: $docPath")
            val apiFuture: ApiFuture<WriteResult> = this.firestore.document(docPath).delete()
            val writeResult: WriteResult = apiFuture.get()
            log.info("Update time: {}", writeResult.updateTime)
        } catch (e: Exception) {
            log.error(e.message)
        }
    }
}