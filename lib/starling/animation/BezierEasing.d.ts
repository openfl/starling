declare namespace starling.animation
{
	/** Provides Cubic Bezier Curve easing, which generalizes easing functions
	 *  via a four-point bezier curve. That way, you can easily create custom easing functions
	 *  that will be picked up by Starling's Tween class later. To set up your bezier curves,
	 *  best use a visual tool like <a href="http://cubic-bezier.com/">cubic-bezier.com</a> or
	 *  <a href="http://matthewlein.com/ceaser/">Ceaser</a>.
	 *
	 *  <p>For example, you can add the transitions recommended by Google's Material Design
	 *  standards (see <a href="https://material.io/design/motion/speed.html#easing">here</a>)
	 *  like this:</p>
	 *
	 *  <listing>
	 *  Transitions.register("standard",   BezierEasing.create(0.4, 0.0, 0.2, 1.0));
	 *  Transitions.register("decelerate", BezierEasing.create(0.0, 0.0, 0.2, 1.0));
	 *  Transitions.register("accelerate", BezierEasing.create(0.4, 0.0, 1.0, 1.0));</listing>
	 *
	 *  <p>The <code>create</code> method returns a function that can be registered directly
	 *  at the "Transitions" class.</p>
	 *
	 *  <p>Code based on <a href="http://github.com/gre/bezier-easing">gre/bezier-easing</a>
	 *  and its <a href="http://wiki.starling-framework.org/extensions/bezier_easing">Starling
	 *  adaptation</a> by Rodrigo Lopez.</p>
	 *
	 *  @see starling.animation.Transitions
	 *  @see starling.animation.Juggler
	 *  @see starling.animation.Tween
	 */
	export class BezierEasing
	{
		/** Create an easing function that's defined by two control points of a bezier curve.
			*  The curve will always go directly through points 0 and 3, which are fixed at
			*  (0, 0) and (1, 1), respectively. Points 1 and 2 define the curvature of the bezier
			*  curve.
			*
			*  <p>The result of this method is best passed directly to
			*  <code>Transitions.create()</code>.</p>
			*
			*  @param x1   The x coordinate of control point 1.
			*  @param y1   The y coordinate of control point 1.
			*  @param x2   The x coordinate of control point 2.
			*  @param y2   The y coordinate of control point 2.
			*  @return     The transition function, which takes exactly one 'ratio:Number' parameter.
			*/
		static create(x1:number, y1:number, x2:number, y2:number):(ratio:number)=>number;
	}
}

export default starling.animation.BezierEasing;