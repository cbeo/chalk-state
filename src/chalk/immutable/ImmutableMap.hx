package chalk.immutable;

import haxe.Constraints;

typedef KeyVal<K,V> = {key:K,value:V};

@:forward(exists, copy, get, iterator, keyValueIterator, keys)
abstract ImmutableMap<K,V>(IMap<K,V>) from IMap<K,V> to IMap<K,V> {
  inline function new(m) {this = m;}

  public function set(k:K,v:V): ImmutableMap<K,V> {
    var copy = this.copy();
    copy.set(k, v);
    return copy;
  }

  public function remove(k:K): ImmutableMap<K,V> {
    if (this.exists(k)) {
      var copy = this.copy();
      copy.remove(k);
      return copy;
    }
    return this;
  }

}