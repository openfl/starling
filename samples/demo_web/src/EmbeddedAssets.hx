package;
class EmbeddedAssets
{
    /** ATTENTION: Naming conventions!
     *  
     *  - Classes for embedded IMAGES should have the exact same name as the file,
     *    without extension. This is required so that references from XMLs (atlas, bitmap font)
     *    won't break.
     *    
     *  - Atlas and Font XML files can have an arbitrary name, since they are never
     *    referenced by file name.
     * 
     */
    
    // Texture Atlas
    
    //[Embed(source="/textures/1x/atlas.xml", mimeType="application/octet-stream")]
    public static var atlas_xml:Class<Dynamic>;
    
    //[Embed(source="/textures/1x/atlas.png")]
    public static var atlas:Class<Dynamic>;

    // Compressed textures
    
    //[Embed(source = "/textures/1x/compressed_texture.atf", mimeType="application/octet-stream")]
    public static var compressed_texture:Class<Dynamic>;
    
    // Bitmap Fonts
    
    //[Embed(source="/fonts/1x/desyrel.fnt", mimeType="application/octet-stream")]
    public static var desyrel_fnt:Class<Dynamic>;
    
    //[Embed(source = "/fonts/1x/desyrel.png")]
    public static var desyrel:Class<Dynamic>;
    
    // Sounds
    
    //[Embed(source="/audio/wing_flap.mp3")]
    public static var wing_flap:Class<Dynamic>;
}