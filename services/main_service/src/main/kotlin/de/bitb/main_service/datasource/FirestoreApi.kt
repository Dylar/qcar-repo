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

    abstract val collectionName: String

    fun getDocumentPath(path: String): String =
        "$collectionName/$path"

    @Throws(ExecutionException::class, InterruptedException::class)
    inline fun <reified T : Any> readDocument(path: String): T? {
        log.info("readDocument: $path")
        // you could reference document by this.firestore.collection("collectionName").document("objName") as well
        val docPath = getDocumentPath(path)
        val apiFuture: ApiFuture<DocumentSnapshot> =
            this.firestore.document(docPath).get()
        val documentSnapshot: DocumentSnapshot = apiFuture.get()
        return documentSnapshot.toObject(T::class.java)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun writeDocument(path: String, obj: T) {
        log.info("writeDocument: $path")
        val docPath = getDocumentPath(path)
        val apiFuture: ApiFuture<WriteResult> = firestore.document(docPath).set(obj)
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.updateTime)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun updateDocument(path: String, obj: T) {
        log.info("updateDocument: $path")
        val docPath = getDocumentPath(path)
        val apiFuture: ApiFuture<WriteResult> = this.firestore.document(docPath)
            .set(obj)
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.updateTime)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    fun deleteDocument(path: String) {
        log.info("deleteDocument: $path")
        // document deletion does not delete its sub collections
        // see https://firebase.google.com/docs/firestore/manage-data/delete-data#collections
        val docPath = getDocumentPath(path)
        val apiFuture: ApiFuture<WriteResult> = this.firestore.document(docPath).delete()
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.updateTime)
    }
}