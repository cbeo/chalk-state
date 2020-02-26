package chalk;

typedef StateTransformType<T> = T -> T;

@:callable
abstract StateTransform<T>(StateTransformType<T>) from StateTransformType<T> to StateTransformType<T> {
  inline function new(tf) {
    this = tf;
  }

  @:op(A >> B)
  public function andThen(other: StateTransform<T>) : StateTransform<T> {
    return (t:T) -> other(this(t));
  }

}
