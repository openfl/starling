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

import starling.utils.StringUtil;
import utest.Assert;
import utest.Test;

class StringUtilTest extends Test
{
	
	public function testFormatString():Void
	{
		Assert.equals("This is a test.", StringUtil.format("This is {0} test.", ["a"]));
		Assert.equals("aba{2}", StringUtil.format("{0}{1}{0}{2}", ["a", "b"]));
		Assert.equals("1{2}21", StringUtil.format("{0}{2}{1}{0}", [1, 2]));
	}

	
	public function testCleanMasterString():Void
	{
		Assert.equals("a", StringUtil.clean("a"));
	}

	
	public function testTrimStart():Void
	{
		Assert.equals("hugo ", StringUtil.trimStart("   hugo "));
		Assert.equals("hugo ", StringUtil.trimStart("\n hugo "));
		Assert.equals("hugo ", StringUtil.trimStart("\r hugo "));
		Assert.equals("", StringUtil.trimStart("\r\n "));
	}

	
	public function testTrimEnd():Void
	{
		Assert.equals(" hugo", StringUtil.trimEnd(" hugo   "));
		Assert.equals(" hugo", StringUtil.trimEnd(" hugo\n "));
		Assert.equals(" hugo", StringUtil.trimEnd(" hugo\r "));
		Assert.equals("", StringUtil.trimEnd("\r\n "));
	}

	
	public function testTrim():Void
	{
		Assert.equals("hugo", StringUtil.trim("   hugo   "));
		Assert.equals("hugo", StringUtil.trim(" \nhugo\r "));
		Assert.equals("hugo", StringUtil.trim(" \nhugo\r "));
		Assert.equals("", StringUtil.trim(" \r \n "));
	}

	
	public function testParseBool():Void
	{
		Assert.isTrue(StringUtil.parseBoolean("TRUE"));
		Assert.isTrue(StringUtil.parseBoolean("True"));
		Assert.isTrue(StringUtil.parseBoolean("true"));
		Assert.isTrue(StringUtil.parseBoolean("1"));
		Assert.isFalse(StringUtil.parseBoolean("false"));
		Assert.isFalse(StringUtil.parseBoolean("abc"));
		Assert.isFalse(StringUtil.parseBoolean("0"));
		Assert.isFalse(StringUtil.parseBoolean(""));
	}
}