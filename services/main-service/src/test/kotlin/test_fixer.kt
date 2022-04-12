import org.assertj.core.api.AbstractObjectAssert
import org.assertj.core.api.ObjectAssert
import java.util.function.Consumer

fun <E : Any?> ObjectAssert<E>.allSatisfyKt(requirements: Consumer<E>): AbstractObjectAssert<*, E> {
    return this.satisfies(requirements)
}