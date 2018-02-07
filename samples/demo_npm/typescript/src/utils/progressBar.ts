import GradientType from "openfl/display/GradientType";
import Shape from "openfl/display/Shape";
import Sprite from "openfl/display/Sprite";
import Matrix from "openfl/geom/Matrix";

class ProgressBar extends Sprite
{
    private _background:Shape;
    private _bar:Shape;

    public constructor(width:number, height:number)
    {
        super();
        this.init(width, height);
    }
    
    private init(width:number, height:number):void
    {
        var padding:number = height * 0.2;
        var cornerRadius:number = padding * 2;
        
        // create black rounded box for background
        
        this._background = new Shape();
        this._background.graphics.beginFill(0x0, 0.5);
        this._background.graphics.drawRoundRect(0, 0, width, height, cornerRadius, cornerRadius);
        this._background.graphics.endFill();
        this.addChild(this._background);
        
        // create progress bar shape

        var barWidth:number  = width  - 2 * padding;
        var barHeight:number = height - 2 * padding;
        var barMatrix:Matrix = new Matrix();
        barMatrix.createGradientBox(barWidth, barHeight, Math.PI / 2);

        this._bar = new Shape();
        this._bar.graphics.beginGradientFill(GradientType.LINEAR,
            [0xeeeeee, 0xaaaaaa], [1, 1], [0, 255], barMatrix);
        this._bar.graphics.drawRect(0, 0, barWidth, barHeight);
        this._bar.x = padding;
        this._bar.y = padding;
        this._bar.scaleX = 0.0;
        this.addChild(this._bar);
    }
    
    public get ratio():number { return this._bar.scaleX; }
    public set ratio(value:number)
    {
        this._bar.scaleX = Math.max(0.0, Math.min(1.0, value));
    }
}

export default ProgressBar;