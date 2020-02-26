package chalk;

import haxe.Constraints;
import chalk.StateTransform;

class ConcreteState<T> {
    var state:T;
    var updateEffectActions:Array<?T->Void> = [];

    public var onTransformError:Function = null;

    function updateEffect(?oldState:T) {
        for (callback in updateEffectActions) callback( oldState );
    }

    public var _read_(get,never):T;

    function get__read_(): T {
        return state;
    }

    public function _write_(tform: StateTransform<T>) {
        var oldState = state;
        try {

            state = tform(state);
            updateEffect( oldState );

        } catch (e:Dynamic) {

            trace('Error on update: $e');

            if (onTransformError != null) {
                trace('Error Handler Exists, Evoking Now');

                try {onTransformError(e);} catch (e2:Dynamic) {
                    trace('Error encountered while attempting to handle state transform error');
                    trace('New Error = $e2');
                }
            }

            trace('Restoring from last good state');
            state = oldState;
            updateEffect();

        }
    }

    public function export():T {
        return Reflect.copy(state);
    }

    public function replace(val:T) {
        this.state = val;
    }

  public function register(callback:?T->Void) {
    updateEffectActions.push(callback);
  }

  public function unregister(callback:?T->Void) {
    updateEffectActions.remove(callback);
  }

  public inline function new(t) {
    state = t;
  }
}

@:forward(_read_,_write_,register,unregister,export,replace)
abstract Model<T>(ConcreteState<T>) {

  inline public function new(t:T) {
    this = new ConcreteState(t);
  }

  @:from
  static public function from<T>(t:T) {
    return new Model(t);
  }

  @:op(a.b)
  public function field<F>(name:String):Lens<T,F> {
    return Lens.on(name);
  }

}

