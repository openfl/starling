package starling.utils;

#if (cs && unsafe)
typedef UInt8Ptr = cs.Pointer<cs.types.UInt8>;
#else
typedef UInt8Ptr = Dynamic;
#end