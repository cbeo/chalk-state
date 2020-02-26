package chalk;

import chalk.StateTransform;

typedef LensType<T,F> =
  { get : (record:T) -> F,
    set : (field:F, record:T) -> T
  };

@:forward(get,set)
abstract Lens<T,F>(LensType<T,F>) from LensType<T,F> to LensType<T,F> {
  inline function new (l) {
    this = l;
  }

  public function compose<G>(other:Lens<F,G>): Lens<T,G> {
    return { get : (t:T) -> other.get( this.get( t ) ),
              set : (g:G,t:T) -> this.set( other.set( g, this.get( t ) ), t )
              };
  }

  @:op(A => B)
  public function assigner(val:F): StateTransform<T> {
    return t -> this.set(val,t);
  }

  @:op(a.b)
  public function dotOp<G>(field:String): Lens<T,G> {
    var other: Lens<F,G> = Lens.on(field);
    return compose(other);
  }

  public static function on<T1,F1>(field:String): Lens<T1,F1> {
    var get = (o:T1) -> (Reflect.field(o, field) : F1);
    var set = (f:F1,o:T1) ->
      {
       var copy = Reflect.copy(o);
       Reflect.setField(copy, field, f);
       return (copy : T1);
      };
    return {get: get, set: set};
  }

  public static function build<T1,F1>(get:(t:T1)->F1, set:(f:F1,t:T1)->T1):Lens<T1,F1> {
    return {set:set,get:get};
  }
}
