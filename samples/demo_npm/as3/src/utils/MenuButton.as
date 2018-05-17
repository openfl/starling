package utils
{
    import openfl.geom.Rectangle;

    import starling.display.Button;

    /** A simple button that uses "scale9grid" with a single texture. */
    public class MenuButton extends Button
    {
        public function MenuButton(text:String, width:Number=128, height:Number=32)
        {
            super(Game.assets.getTexture("button_normal"), text);
        
            this.textFormat.font = "DejaVu Sans";
            this.scale9Grid = new Rectangle(12.5, 12.5, 20, 20);
            this.width = width;
            this.height = height;
        }
    }
}