package chalk.immutable;

@:forward(iterator, filter, map)
abstract ImmutableArray<T>(Array<T>) from Array<T> to Array<T> {
  inline function new (a:Array<T>) {this = a;}

  @:arrayAccess
  public function item(i:Int):Null<T> {
    return this[i];
  }

  public function set(i:Int,val:T):ImmutableArray<T> {
    var a:Array<T> = this.copy();
    a[i] = val;
    return a;
  }

  public function append(val:T):ImmutableArray<T> {
    var a:Array<T> = this.copy();
    a.push(val);
    return a;
  }

}