package starling.utils;

//http://try.haxe.org/#9714d
abstract AcceptEither<A, B, C, D, E, F, G> (Either<A, B, C, D, E, F, G>) {
	
	public inline function new( e:Either<A, B, C, D, E, F, G> ) this = e;
	
	public var value(get,never):Dynamic;
	public var type(get,never):Either<A, B, C, D, E, F, G>;

	inline function get_value() {
		switch (this) 
		{ 
			case TypeA(v) | TypeB(v) | TypeC(v) | TypeD(v) | TypeE(v) | TypeF(v) | TypeG(v): return v; 
		}
	}
	@:to inline function get_type() return this;
	
	@:from static function fromA<A>( v:A ) return new AcceptEither( TypeA(v) );
	@:from static function fromB<B>( v:B ) return new AcceptEither( TypeB(v) );
    @:from static function fromC<C>( v:C ) return new AcceptEither( TypeC(v) );
	@:from static function fromD<D>( v:D ) return new AcceptEither( TypeD(v) );
	@:from static function fromE<E>( v:E ) return new AcceptEither( TypeE(v) );
	@:from static function fromF<F>( v:F ) return new AcceptEither( TypeF(v) );
	@:from static function fromG<G>( v:G ) return new AcceptEither( TypeG(v) );
}

enum Either<A, B, C, D, E, F, G> {
  TypeA( v:A );
  TypeB( v:B );
  TypeC( v:C );
  TypeD( v:D );
  TypeE( v:E );
  TypeF( v:F );
  TypeG( v:G );
}