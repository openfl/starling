

declare namespace starling.textures
{
    /** A class that provides constant values for the possible smoothing algorithms of a texture. */ 
    export class TextureSmoothing
    {
        /** No smoothing, also called "Nearest Neighbor". Pixels will scale up as big rectangles. */
        public static NONE:string;
        
        /** Bilinear filtering. Creates smooth transitions between pixels. */
        public static BILINEAR:string;
        
        /** Trilinear filtering. Highest quality by taking the next mip map level into account. */
        public static TRILINEAR:string;
        
        /** Determines whether a smoothing value is valid. */
        public static isValid(smoothing:string):boolean
        {
            return smoothing == NONE || smoothing == BILINEAR || smoothing == TRILINEAR;
        }
    }
}

export default starling.textures.TextureSmoothing;