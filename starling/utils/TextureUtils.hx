package starling.utils;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.Context3DProgramType;

class TextureUtils
{
    public static function ToContext3DTextureFormat(format:String):Context3DTextureFormat
    {
        switch(format)
        {
        case "bgra": return Context3DTextureFormat.BGRA;
        case "compressed": return Context3DTextureFormat.COMPRESSED;
        case "compressedAlpha": return Context3DTextureFormat.COMPRESSED_ALPHA;
        default: return Context3DTextureFormat.BGRA;
        }
    }

    public static function ProgramTypeToString(type:Context3DProgramType):String
    {
        switch(type)
        {
        case Context3DProgramType.FRAGMENT: return "fragment";
        case Context3DProgramType.VERTEX: return "vertex";
        default: return "";
        }
    }
}