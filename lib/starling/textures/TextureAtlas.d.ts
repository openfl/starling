import Std from "./../../Std";
import openfl_geom_Rectangle from "openfl/geom/Rectangle";
import openfl_Vector from "openfl/Vector";
import starling_textures_SubTexture from "./../../starling/textures/SubTexture";
import haxe_ds_StringMap from "./../../haxe/ds/StringMap";

declare namespace starling.textures {

export class TextureAtlas {

	constructor(texture:any, atlasXml?:any);
	__atlasTexture:any;
	__subTextures:any;
	__subTextureNames:any;
	dispose():any;
	getXmlFloat(xml:any, attributeName:any):any;
	parseAtlasXml(atlasXml:any):any;
	getTexture(name:any):any;
	getTextures(prefix?:any, result?:any):any;
	getNames(prefix?:any, result?:any):any;
	getRegion(name:any):any;
	getFrame(name:any):any;
	getRotation(name:any):any;
	addRegion(name:any, region:any, frame?:any, rotated?:any):any;
	removeRegion(name:any):any;
	texture:any;
	get_texture():any;
	compare(a:any, b:any):any;
	static sNames:any;
	static parseBool(value:any):any;


}

}

export default starling.textures.TextureAtlas;