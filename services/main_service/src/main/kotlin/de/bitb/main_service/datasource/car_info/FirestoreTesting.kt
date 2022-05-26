package de.bitb.main_service.datasource.car_info

import com.google.api.core.ApiFuture
import com.google.cloud.firestore.DocumentSnapshot
import com.google.cloud.firestore.Firestore
import com.google.cloud.firestore.WriteResult
import de.bitb.main_service.models.CarInfo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import java.util.concurrent.ExecutionException


class CarInfoFirestoreApi<T> @Autowired constructor(
    private val firestore: Firestore
) {

    private val log: Logger = LoggerFactory.getLogger(CarInfoFirestoreApi::class.java)
    private val collectionName: String = "car_info"

    private fun getDocumentPath(carInfo: CarInfo): String =
        "$collectionName/${carInfo.brand}/${carInfo.model}"

    @Throws(ExecutionException::class, InterruptedException::class)
    private fun readDocument(brand: String, model: String): CarInfo? {
        log.info("readDocument")
        // you could reference document by this.firestore.collection("collectionName").document("objName") as well
        val apiFuture: ApiFuture<DocumentSnapshot> = this.firestore.document("$collectionName/$brand/$model").get()
        val documentSnapshot: DocumentSnapshot = apiFuture.get()
        return documentSnapshot.toObject(CarInfo::class.java)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    private fun writeDocument(info: CarInfo) {
        log.info("writeDocument")
        val path = getDocumentPath(info)
        val apiFuture: ApiFuture<WriteResult> = firestore.document(path).set(info)
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.updateTime)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    private fun updateDocument(info: CarInfo) {
        log.info("updateDocument")
        val path = getDocumentPath(info)
        val apiFuture: ApiFuture<WriteResult> = this.firestore.document(path)
            .set(info)
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.updateTime)
    }

    @Throws(ExecutionException::class, InterruptedException::class)
    private fun deleteDocument(info: CarInfo) {
        log.info("deleteDocument")
        // document deletion does not delete its sub collections
        // see https://firebase.google.com/docs/firestore/manage-data/delete-data#collections
        val path = getDocumentPath(info)
        val apiFuture: ApiFuture<WriteResult> = this.firestore.document(path).delete()
        val writeResult: WriteResult = apiFuture.get()
        log.info("Update time: {}", writeResult.getUpdateTime())
    }
}

//@Throws(ExecutionException::class, InterruptedException::class)
//private fun insertCarInfos() {
//    val futures: MutableList<ApiFuture<WriteResult>> = ArrayList()
//    val users: CollectionReference = this.firestore.collection("users")
//    futures.add(
//        users.document("tom").set(
//            CarInfo("tom", 18, Gender.MALE, Arrays.asList("ESports", "Swimming"))
//        )
//    )
//    futures.add(
//        users.document("stella").set(
//            CarInfo("stella", 25, Gender.MALE, Arrays.asList("Embroidery", "Cooking", "Swimming"))
//        )
//    )
//    futures.add(
//        users.document("john").set(
//            CarInfo("john", 28, Gender.MALE, Arrays.asList("Programming", "Cricket"))
//        )
//    )
//    // blocking get
//    val writeResults: List<WriteResult> = ApiFutures.allAsList(futures).get()
//    writeResults.forEach(Consumer<WriteResult> { r: WriteResult ->
//        logger.info(
//            "Updated time: {}",
//            r.getUpdateTime()
//        )
//    })
//}
//
//@Throws(ExecutionException::class, InterruptedException::class)
//private fun insertCarInfosBatch() {
//    val batch: WriteBatch = this.firestore.batch()
//    val users: CollectionReference = this.firestore.collection("users")
//    batch.set(
//        users.document("tom"),
//        CarInfo("tom", 18, Gender.MALE, Arrays.asList("ESports", "Swimming"))
//    )
//    batch.set(
//        users.document("stella"),
//        CarInfo("stella", 25, Gender.MALE, Arrays.asList("Embroidery", "Cooking", "Swimming"))
//    )
//    batch.set(
//        users.document("john"),
//        CarInfo("john", 28, Gender.MALE, Arrays.asList("Programming", "Cricket"))
//    )
//    val commit: ApiFuture<List<WriteResult>> = batch.commit()
//    // blocking get
//    commit.get().forEach(Consumer<WriteResult> { r: WriteResult ->
//        logger.info(
//            "Updated time: {}",
//            r.getUpdateTime()
//        )
//    })
//}
//
//@Throws(ExecutionException::class, InterruptedException::class)
//private fun getCarInfosByGender(gender: Gender): List<CarInfo?>? {
//    val users: CollectionReference = this.firestore.collection("users")
//    val future: ApiFuture<QuerySnapshot> = users.whereEqualTo("gender", gender.name()).get()
//    // blocking get
//    val queryDocumentSnapshots: QuerySnapshot = future.get()
//    return queryDocumentSnapshots.getDocuments()
//        .stream()
//        .map { d -> d.toObject(CarInfo::class.java) }
//        .collect(Collectors.toList())
//}
//
//private fun getCarInfosByGenderAsync(gender: Gender, consumer: Consumer<List<CarInfo>>) {
//    val users: CollectionReference = this.firestore.collection("users")
//    users.whereEqualTo("gender", gender.name()).addSnapshotListener { value, error ->
//        if (value != null) {
//            val results: List<CarInfo> = value.getDocuments()
//                .stream()
//                .map { d -> d.toObject(CarInfo::class.java) }
//                .collect(Collectors.toList())
//            consumer.accept(results)
//        }
//    }
//}
//
//private fun getCarInfosByAges(ages: List<Int>, consumer: Consumer<List<CarInfo>>) {
//    val users: CollectionReference = this.firestore.collection("users")
//    users.whereIn("age", ages).addSnapshotListener { value, error ->
//        if (value != null) {
//            val results: List<CarInfo> = value.getDocuments()
//                .stream()
//                .map { d -> d.toObject(CarInfo::class.java) }
//                .collect(Collectors.toList())
//            consumer.accept(results)
//        }
//    }
//}
//
//private fun getCarInfosByInterests(interests: List<String>, consumer: Consumer<List<CarInfo>>) {
//    val users: CollectionReference = this.firestore.collection("users")
//    users.whereArrayContainsAny("interests", interests).addSnapshotListener { value, error ->
//        if (value != null) {
//            val results: List<CarInfo> = value.getDocuments()
//                .stream()
//                .map { d -> d.toObject(CarInfo::class.java) }
//                .collect(Collectors.toList())
//            consumer.accept(results)
//        }
//    }
//}
//
//private fun getCarInfosInAgeRange(minAge: Int, maxAge: Int, consumer: Consumer<List<CarInfo>>) {
//    val users: CollectionReference = this.firestore.collection("users")
//    users.whereGreaterThanOrEqualTo("age", minAge)
//        .whereLessThanOrEqualTo("age", maxAge)
//        .addSnapshotListener { value, error ->
//            if (value != null) {
//                val results: List<CarInfo> = value.getDocuments()
//                    .stream()
//                    .map { d -> d.toObject(CarInfo::class.java) }
//                    .collect(Collectors.toList())
//                consumer.accept(results)
//            }
//        }
//}
//
//@Throws(ExecutionException::class, InterruptedException::class)
//private fun updateAddresses() {
//    val users: CollectionReference = this.firestore.collection("users")
//    val futures: MutableList<ApiFuture<WriteResult>> = ArrayList()
//    futures.add(
//        users.document("tom")
//            .collection("addresses").document(Address.Type.RESIDENCE.name())
//            .set(Address("USA", "Los Angeles", "CA", "York Street", Address.Type.RESIDENCE))
//    )
//    futures.add(
//        users.document("john")
//            .collection("addresses").document(Address.Type.RESIDENCE.name())
//            .set(Address("USA", "San Francisco", "CA", "San Street", Address.Type.RESIDENCE))
//    )
//    ApiFutures.allAsList(futures).get()
//}
//
//private fun getCarInfosLiveInCity(city: String, consumer: Consumer<List<CarInfo>>) {
//    val users: Query = this.firestore.collectionGroup("addresses")
//        .whereEqualTo("city", city)
//    users.addSnapshotListener { value, error ->
//        if (value != null) {
//            val results: List<CarInfo> = value.getDocuments()
//                .stream()
//                .map { d -> d.toObject(CarInfo::class.java) }
//                .collect(Collectors.toList())
//            consumer.accept(results)
//        }
//        if (error != null) {
//            logger.error("failed", error)
//        }
//    }
//}