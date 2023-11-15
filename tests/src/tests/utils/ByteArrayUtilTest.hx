// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package tests.utils;

import openfl.utils.ByteArray;
import starling.utils.ByteArrayUtil;
import utest.Assert;
import utest.Test;

class ByteArrayUtilTest extends Test
{
	
	public function testStartsWith():Void
	{
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeUTFBytes("  \n<Hello World/>");

		Assert.isTrue(ByteArrayUtil.startsWithString(byteArray, "<Hello"));
		Assert.isFalse(ByteArrayUtil.startsWithString(byteArray, "<Holla"));
	}

	
	public function testStartsWithBytes():Void
	{
		var byteArray:ByteArray = new ByteArray();
		byteArray.writeByte(0xaa); byteArray.writeByte(0xbb);
		byteArray.writeByte(0xcc); byteArray.writeByte(0xdd);

		Assert.isTrue(ByteArrayUtil.startsWithBytes(byteArray,  [0xaa, 0xbb, 0xcc]));
		Assert.isTrue(ByteArrayUtil.startsWithBytes(byteArray,  [0xaa, 0xbb, 0xcc, 0xdd]));
		Assert.isFalse(ByteArrayUtil.startsWithBytes(byteArray, [0xaa, 0xbb, 0xcc, 0xdd, 0xee]));
		Assert.isFalse(ByteArrayUtil.startsWithBytes(byteArray, [0xaa, 0xbb, 0xc1]));
	}

	
	public function testCompare():Void
	{
		var a:ByteArray = new ByteArray();
		var b:ByteArray = new ByteArray();
		var c:ByteArray = new ByteArray();

		a.writeUTFBytes("Hello World");
		b.writeUTFBytes("Hello Starling");
		c.writeUTFBytes("Good-bye World");

		Assert.isFalse(ByteArrayUtil.compareByteArrays(a, 0, b, 0));
		Assert.isTrue(ByteArrayUtil.compareByteArrays(a, 0, b, 0, 6));
		Assert.isTrue(ByteArrayUtil.compareByteArrays(a, 0, a, 0));
		Assert.isTrue(ByteArrayUtil.compareByteArrays(a, 5, c, 8));
	}
}