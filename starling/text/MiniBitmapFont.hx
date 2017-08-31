// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.text;

import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

import haxe.Int64;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.zip.InflateImpl;

import starling.textures.Texture;

/** @private
 *  This class contains constants for the 'MINI' bitmap font. It's done that way to avoid
 *  a dependency on the 'mx.core' library (which is required for the 'Embed' statement).
 * 
 *  <p>The font is based on "uni05_53.ttf" from Craig Kroeger (http://www.miniml.com) and was
 *  converted to a Bitmap Font with "GlyphDesigner" from 71squared (http://www.71squared.com).
 *  </p>
 *
 *  <p>You can download a zip-file containing the bitmap font (with both XML and PNG files)
 *  <a href="http://gamua.com/media/starling/misc/bitmapfont-mini.zip">here</a>.</p>
 */
class MiniBitmapFont
{
    private static inline var BITMAP_WIDTH:Int = 128;
    private static inline var BITMAP_HEIGHT:Int = 64;
    // private static var BITMAP_DATA:Array<UInt> = [
    //     2027613533, 3413039936,  202148514, 2266925598, 4206886452, 4286853117,    2034947,
    //     3202703399,  352977282, 2957757964, 3113652880, 2158068882, 1468709156, 2268063717,
    //     2779310143, 2101025806, 3416509055, 4215794539, 3602168838, 1038056207, 1932393374,
    //     3182285627, 3086802234, 1741291262, 2017257123, 3395280843,  984074419, 3049693147,
    //     3986077023, 1055013549, 1806563255, 1754714962, 1577746187, 1124058786, 3888759258,
    //     2482229043, 2916583666, 3743065328,  866060213, 1695195001, 2401582068, 3113347901,
    //     2616521596, 1053798161, 2093370968, 4229025683,  560451479,  854767518, 2610241322,
    //     4279041348, 4181572480, 4031244973,  587139110, 1081376765,  962217926,  783603325,
    //     3605526425, 4102001916,  289204733, 2635140255, 3453981695, 3487854373, 2132197241,
    //     3164775074, 4257640328,  770238970,  144664537,  707141570, 2934433071,  871272893,
    //         512964596,  808491899,  481894297, 3095982481, 3598364156, 1710636358, 2904016319,
    //     1751040139,  596966466, 1363963692,  465815609,  315567311, 4290666159, 4086022551,
    //         179721458, 2221734970, 3942224988, 1519355876, 3292323782, 3933427230, 3314199893,
    //     3736227348, 3846038425,  603088884, 2677349227, 3207069327, 3555275967, 3063054283,
    //     3064577213, 3412044179,  693642210, 4280513949,  762928717, 1802215333, 3774849674,
    //     4221155330,  970959395,  557220237, 2107226136, 3509822982, 3403284788, 4265820019,
    //         898597576,  991077243, 2091615904, 3334716888,  633599866, 4218780109, 2216000376,
    //         834870947, 2118009742, 1362731961,  236280636, 1274945142, 1458729366,  797960805,
    //     3289369720, 2103717340, 3946406003, 2676522889, 1624104606, 1156993903, 3186170404,
    //     2254499071, 1204911924, 1314218830, 3307086392, 2824275959, 3839865679, 2073394964,
    //     1873329433, 1754205930, 1528429545, 1631106062, 2263272465, 4220497047, 3522893765,
    //     3641376303,  707451487, 3452496787, 1390653868, 2620555793, 1027328684, 3419683476,
    //     3662193703,  765701986, 3808279132,  786403271, 3824435837,  713234896, 4261856399,
    //     3471930731, 3993492879, 1447960461, 1398434593, 1914230187, 2398643285, 4156374464,
    //     3859339207, 3220700061, 3373248762, 3186030434, 1315917060, 2809852481, 4008553903,
    //     4105611953, 1599499652, 3513857591,  877854499, 4198259455, 3648560077, 2838035419,
    //     3255594190, 2465578457, 4263505201,  534904657, 2889261598, 1358214576, 1069250354,
    //     3870010557, 2628896583, 3448610878,  442343309, 1024736866, 4015119133, 3250867279,
    //     1513359261, 2442089596, 1944476762,  735490552,  426990058, 4234106111, 1204305707,
    //     3330995265, 2398649368, 4221048123, 1724669255, 3801115709, 3489328790, 3896402933,
    //     3696936939, 2836983295, 3656750393, 3349724512, 3810416287, 3654997608, 4284455103,
    //     2294939563, 4207697932,  642748805, 2476981639, 2319419898,  572956615, 3833238940,
    //         964924880, 2081600351, 3572458416, 2056247513, 1951368808, 2133449703, 2783728628,
    //         512866577,  913279200, 1678129016, 3488578991, 3373952929, 2562996951, 3666058925,
    //     1664169178, 1943591935,  750675303,  154399903, 2571590890,  852654952, 4117307766,
    //     1971649621, 4180195820, 1222535348, 4283953215, 2880662236, 2717410980, 1175907705,
    //     1157322027,  505963121, 2631540616, 3661227656, 3591803353, 2624126821, 1948662907,
    //     3596065103, 1147387734,  256773959, 1173572460, 2361957471, 4210876076, 3080180620,
    //     3464801210, 3821654259, 1465302035, 2851185457, 3143266144, 3793180414, 3368833103,
    //     4274670712, 3473819108, 3487569332,  773123355, 1618635668, 2570176190, 2075248691,
    //     1740805534,  288646743, 1837597401,  603556968, 3182536872,  673184603, 3088757053,
    //     2897054404, 3192651316, 2885335802, 1057233368, 1118437241, 4182126463, 3110464775,
    //     3313191614, 2360987274,  735505357, 2992631425, 2360928811, 4187834527,  279183208,
    //     1586420003, 1174008423, 4062987589, 1162167621, 1162167621, 1162167621, 1162167621,
    //     1174119799,  787274608
    // ];
    private static var BITMAP_DATA:Array<UInt> = [ 
		0x78daed5d, 0xcb6edb40, 0xc0c8aa2, 0x871e8a1e, 0xfabffe34, 0xff842ffd, 0x1f0d03, 
		0xbee56027, 0x150a0182, 0xb04bce0c, 0xb9969290, 0x80a18492, 0x578ab924, 0x872fe7e5, 
		0xa5a8e83f, 0x7d3b1c0e, 0xcba3ca7f, 0xfb47eb6b, 0xd6b4bc06, 0x3ddf7b0f, 0x732dfb9e, 
		0xbdadd33b, 0xb7fcdd3a, 0x67c9fefe, 0x783ce6a3, 0xca5fdfcb, 0x3aa7c8b3, 0xb5c69fdb, 
		0xed96b55f, 0x3ee23aad, 0x6badf7b7, 0x6896d352, 0x5e0a7f0b, 0x42ffc6a2, 0xe7c9c1da, 
		0x93f3cf33, 0xadd788f2, 0xdf1aa4f0, 0x339f07b5, 0x650a9f79, 0x8f253bf4, 0xb991eb3d, 
		0x9bf4f37c, 0x3ecfaf11, 0x7cc64e58, 0xfc11cf93, 0x2167cf97, 0x32f2b79e, 0x9b951f2a, 
		0xff0cfd44, 0xf93dbb80, 0xf047eaad, 0x22ff0826, 0x40747ffd, 0x395a47c6, 0x2eb4d67d, 
		0xd6e7f799, 0xf47f94fc, 0x113ce9fd, 0x9d110c9f, 0xcddf93ff, 0xcfe46f25, 0x7f16bf79, 
		0xbca2a2a2, 0xfdc66f88, 0x2de8e9fa, 0x89f67d9, 0x2a261fc2, 0xaee7e52f, 0x33ee91bd, 
		0x1e9337f4, 0x30309b7b, 0x1cb91f99, 0xb888f191, 0xd67aadfc, 0x65f63d46, 0xad17c5bf, 
		0x685ec08b, 0x2394fc42, 0x514c6f2c, 0x1bc3c839, 0x12cf2ccf, 0xffbe5eaf, 0xf38bc197, 
		0xab654f2, 0x846cfc3a, 0xeaf9945c, 0x5a8f87e4, 0xc43cdfc6, 0xea73561e, 0xc58aad55, 
		0xdeb24e14, 0xe53de399, 0x23f267f4, 0x9f951b6b, 0xbf27fe8f, 0xd3e934bf, 0xb6927fcb, 
		0xb6a9bcbd, 0xcb5fa993, 0x295823e2, 0xff23759d, 0x2d795e4d, 0x6b6b9fa5, 0xe0ffa28a, 
		0xfb99b802, 0x39dfaa23, 0x2136818d, 0x7d99b818, 0xd133a606, 0xcada0134, 0xfe433f73, 
		0x358f82c8, 0x3b12a37b, 0x7cab86a0, 0xc6c3bdd8, 0x25c3f77a, 0xfb7579cd, 0x84157b78, 
		0x31c31ea3, 0x7e3e438e, 0x5139a3b9, 0xe155b3c, 0x4bfe1e76, 0x56f27196, 0x2f8fea65, 
		0xc40fcc78, 0x7d642ddc, 0xeb396073, 0x9f887f89, 0x60cdde9e, 0x44f6536f, 0xbde91a24, 
		0x8660ecff, 0x47d17f34, 0x4e55634e, 0xc51e2238, 0xa85707f7, 0xe4dfb34f, 0x7b957f14, 
		0x6fa8bd19, 0x688f0eea, 0x5b19fbe9, 0x6138b40e, 0x86e6cc11, 0xfb8fac97, 0xd1fb17c5, 
		0xd90afe2f, 0x2a2ada5f, 0xcdc8eb93, 0x52e3b1ac, 0x9c328211, 0x3d3bcaac, 0xcbd43a94, 
		0xda48a427, 0x2da3af62, 0xe2fdba5c, 0x2edf8fc7, 0xe3f4427d, 0x2a8319d0, 0xfe06c48f, 
		0xcef1756b, 0xee07dd8f, 0x564e1f8d, 0x535a6b21, 0x7218d5ab, 0x8ef86455, 0xf7bd3dc0, 
		0xe608d7c7, 0xbff7fb9d, 0xc90fb0fa, 0xbde6f762, 0x4e6f4d04, 0xa77af241, 0xeeedadaf, 
		0xf4b6aab1, 0x5f566d84, 0xd1713637, 0x3452ff23, 0xfa3c5aff, 0xd9789bcd, 0xa928fbdb, 
		0xc20c6cce, 0x92f5bdd9, 0xfe1fed31, 0x1fe1ff51, 0xac36a21e, 0x50f4b5b0, 0x3fbb7732, 
		0xe6abacbd, 0x9cb1c747, 0xcd8da03e, 0x1a5d9f8d, 0x3d143e62, 0xef51db1d, 0xc1c44c4f, 
		0x5a34079d, 0x918f547c, 0x73e65c5a, 0x2bd6b1f8, 0x197359ea, 0xfc5f54ff, 0x47c83f2b, 
		0xc68af441, 0x8ef87c18, 0xfb98153b, 0x66cc5d47, 0xe2906c3d, 0xcffaee96, 0xe83e63f5, 
		0xdc5ac7eb, 0xa918edff, 0xd9f59539, 0xc7a8bd60, 0xe31e569f, 0xd9dad668, 0xff5f98bf, 
		0x88c9ffab, 0xfacc600c, 0x264f9185, 0x93a3bd87, 0x8a3f89fa, 0x22269fc7, 0xe47a959c, 
		0x398395d0, 0x7c12b35f, 0xd4ef63b0, 0x7a8fd8d9, 0x744f8668, 0x7f29dbe7, 0xa5ec53f4, 
		0x1e91b911, 0x366f88e0, 0x64063778, 0xcfef7daf, 0xc91a6fa1, 0x98c43ad7, 0xda839ead, 
		0x633134da, 0x73d8dbff, 0x2cbe6567, 0x933f49f, 0x99475cea, 0x32d27b68, 0xf5692176, 
		0x7584fc55, 0xf928b9ec, 0x48de68b4, 0xff57f03f, 0xabb36adc, 0xa1f866a4, 0x4616ed79, 
		0x44fb552b, 0x1e286271, 0x9cda1f88, 0xda39e688, 0xd61691d9, 0x9c68ff65, 0x74263c7b, 
		0xd657994f, 0x4463bf56, 0xf4e0f47, 0x45f34b6c, 0x8cc89c5f, 0xfafcdeac, 0xb797d38c, 
		0xce84abba, 0xe3c9d0f3, 0x5756bc13, 0xa9f1a331, 0xbb5a6f60, 0xe21756fe, 0xc8cc504f, 
		0xfeca4c78, 0xcf0e45e4, 0xcfe015b4, 0x2e14ed1b, 0x607a6b94, 0x9931c6be, 0x7bb1c833, 
		0x67c2959e, 0x11346657, 0x6d8782d9, 0x23f98c68, 0xbdb1a8a8, 0x281ffb5b, 0xb81ab13d, 
		0xacad8ac4, 0xbe4bfe34, 0xabfabafa, 0x3f0419d8, 0x42a9ff79, 0xf9462f7f, 0xb965ed07, 
		0xc57b4abe, 0x8cb9ce8a, 0x2bd6ebcd, 0xb25fee81, 0x8cb8ea2b, 0xf99d489f, 0x10a3ff68, 
		0x5e8ed923, 0x45f9f267, 0xf22c4545, 0x45454545, 0x45454545, 0x45454545, 0x45454545, 
		0x45fba577, 0x2eecdb70, 
    ];
    
    // private static var XML_DATA:Array<UInt> = [
    //     2027597212, 3413252919,  272990085, 3317550056, 3334163186, 3257663297, 3591128409,
    //     2890425386, 2761111647,  527618147,   52430618, 2364524198, 1760684058, 2369863585,
    //     3474923166, 2408051623, 2281562617, 3095060076, 2005920695, 4251041630, 2650210141,
    //     1585968618, 4158909395, 3814370647, 4227065461, 3206373022, 3733899251, 3421889991,
    //     1326439395, 3688624560, 2061311862, 1601633199,  803730609, 3454661241, 2147081965,
    //     3866490843, 3818535112,  392109783, 3467401087, 1858006606, 2549591983, 3061836958,
    //     1188875238, 2949868155, 4235638912,  684866237, 3050979165, 3216305109, 3217254334,
    //         260046515, 2142956216, 3170574911,  979287777, 4177296602, 2634524127, 3352764408,
    //     4061109159, 3208087531, 4291923263, 1774236298,   64390065, 2761120269, 3864715718,
    //     2322325223, 2853989163, 1817861174, 1345078606, 3627597066, 1634342248, 2048207014,
    //     1439700685,  889444112, 2599097303, 1673112788, 3233094349, 2781121896, 1859784462,
    //     1815586484,  245289180, 3020824173,  927656720, 3497436084, 3473070702,  335965828,
    //     3677167038, 2765129315,  305200265, 1930001523, 2968255456,  728531660,  366545081,
    //     2530000716,  382716266,  509201668, 1805089764, 3144412199, 2966275026, 3843995915,
    //     2874857560, 2028220014,  864036925,  843722579, 3658443969, 1548642213,  640956393,
    //     3577181747, 2648451636, 3786701581, 2746855152, 3375918650, 2200787631, 1312736162,
    //     4125799551,  492597210,  252620343, 3976695766, 1800036239, 3817516935, 3947722251,
    //     1891486062,  296630233,  767751566,  822368944, 1432685697,   55275586, 1891980552,
    //     3506824774,  516416227, 4165382638, 4109739522,  390692164, 1637719233, 1479322500,
    //     2368975173, 2225514211,  672826186, 1568913875, 1824186394, 3653266945, 2518308906,
    //         35525686,  653048005, 1616403844, 1361587273, 3094588780, 2505882319, 2776202028,
    //     2757087402, 3328627097, 3952038601, 1237697581, 3770057333, 4018923532, 2790774465,
    //     2214943965, 3762992238, 1305294237, 3706356884, 2363377204, 1470247860, 1581879325,
    //     1521437675, 3768051941, 1448385834,  276728158, 1785811956,  269260971, 2846409888,
    //     3600278860, 2406006054, 3114305630, 1607144004, 3239524360, 3102051805, 2486660692,
    //         896281643, 1014447558,  752047569, 3277336169, 4209190282, 1501241799,   93461344,
    //     2317421519, 2928258400, 3813649565, 4080047018, 3088226780, 2151884600, 2530096045,
    //     2211756338, 2901394566, 3390670300, 3607345457, 2009739438, 1008387796, 1490520565,
    //     3587808834,  508254254, 2879706886,  741828625,  753731096, 3625260424,  208354225,
    //     1701634724, 3994665048, 2675652636, 1448739338, 2353893188, 1951968343, 1167130823,
    //         502991968, 2742645147,   79075887, 1526806702, 3474769333, 2726863238, 2886959267,
    //         378339352,  916995117, 3328260559, 1601263773, 1996583128, 2718531779, 1242497133,
    //         845742496, 1294401036, 1840428143,  500720658, 2335813833, 2759518913,  647223977,
    //         127618258, 2483041945, 1290486960, 3383021083, 3508966148, 1168207334, 2337541574,
    //         898800912, 3630843636,  853044242, 2383033762, 2657078941,  613038758, 2484767541,
    //     1169366183, 3591786002, 2794851111, 2311229988,  282764217, 2976944944, 2922874271,
    //     2222007734, 2975904561, 3116520386, 3094491192, 2967299193, 4253931852,  666250385,
    //     4179795844, 1638213140, 3228191078,  423837811, 3310994165, 1244860588, 1462137215,
    //         945886295,  440427430, 2321254216, 1170019334, 1713271776, 2147913693, 1827968672,
    //     2082532922, 4017118097, 2659527947, 3343803853, 1813812659, 1580633162, 1671513475,
    //     3113396937, 1677954251,  985222302, 1806934566, 3484262014, 2444715872, 3994311733,
    //     3747831434, 2254536017,  248033492, 2309838657,  572362214, 2264662528, 2351674224,
    //     3671049426, 3168085287, 1576925355, 1919659723, 4012572823, 3070764083, 1859557424,
    //     1935302741, 3276007101,  761379244, 1440644487, 1902318063, 1700320137, 2904729752,
    //     4144980056, 1388643363, 2385229611,   39497692, 2919788733,  916414468, 1920818806,
    //         24265681, 2629861817, 2623538306, 3113771140, 2170113095,   72797283, 2911429019,
    //         573565656, 3145961894, 2136506532, 4116780896, 2615237068, 2721979478, 3941798645,
    //     1700588260, 2524858588,  652061762, 2523917061, 1130418869, 1665299237, 3874687928,
    //     2790598641, 2031355348, 3958550756, 4269199613, 3678480072, 3448593534,  535537315,
    //         489382669, 2930887156, 1148245624, 3569761183, 2714134023,   63949312, 3940116119,
    //     1607367711, 1022608529, 2064987700, 2361851206, 2472236914,  233094865, 2017560618,
    //     1834051537, 1553591560,  196640410,  737779879, 3324437502, 2471243439, 4225110860,
    //     1943295493, 1788573635, 4000264602, 1944081486, 1305624985,  432107877, 1747235854,
    //         479892319, 3581570398, 3816529723, 4146099065, 3229056819, 3499918252, 1253025017,
    //         518193838, 1768206194, 3141161437,  262863433, 1431520128, 2096843900,  478027203,
    //     3857703383, 1157369823, 1528368128
    // ];
    private static var XML_DATA:Xml = Xml.parse('<font>
      <info face="mini" size="8" bold="0" italic="0" smooth="0"/>
      <common lineHeight="8" base="7" scaleW="128" scaleH="64" pages="1" packed="0"/>
      <chars count="191">
        <char id="195" x="1" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
        <char id="209" x="7" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
        <char id="213" x="13" y="1" width="5" height="9" xoffset="0" yoffset="-2" xadvance="6"/>
        <char id="253" x="19" y="1" width="4" height="9" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="255" x="24" y="1" width="4" height="9" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="192" x="29" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="193" x="35" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="194" x="41" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="197" x="47" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="200" x="53" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="201" x="59" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="202" x="65" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="210" x="71" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="211" x="77" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="212" x="83" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="217" x="89" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="218" x="95" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="219" x="101" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="221" x="107" y="1" width="5" height="8" xoffset="0" yoffset="-1" xadvance="6"/>
        <char id="206" x="113" y="1" width="3" height="8" xoffset="-1" yoffset="-1" xadvance="2"/>
        <char id="204" x="117" y="1" width="2" height="8" xoffset="-1" yoffset="-1" xadvance="2"/>
        <char id="205" x="120" y="1" width="2" height="8" xoffset="0" yoffset="-1" xadvance="2"/>
        <char id="36"  x="1" y="11" width="5" height="7" xoffset="0" yoffset="1" xadvance="6"/>
        <char id="196" x="7" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
        <char id="199" x="13" y="11" width="5" height="7" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="203" x="19" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
        <char id="214" x="25" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
        <char id="220" x="31" y="11" width="5" height="7" xoffset="0" yoffset="0" xadvance="6"/>
        <char id="224" x="37" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="225" x="42" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="226" x="47" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="227" x="52" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="232" x="57" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="233" x="62" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="234" x="67" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="235" x="72" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="241" x="77" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="242" x="82" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="243" x="87" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="244" x="92" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="245" x="97" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="249" x="102" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="250" x="107" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="251" x="112" y="11" width="4" height="7" xoffset="0" yoffset="0" xadvance="5"/>
        <char id="254" x="117" y="11" width="4" height="7" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="123" x="122" y="11" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
        <char id="125" x="1" y="19" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
        <char id="167" x="5" y="19" width="3" height="7" xoffset="0" yoffset="1" xadvance="4"/>
        <char id="207" x="9" y="19" width="3" height="7" xoffset="-1" yoffset="0" xadvance="2"/>
        <char id="106" x="13" y="19" width="2" height="7" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="40" x="16" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
        <char id="41" x="19" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
        <char id="91" x="22" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
        <char id="93" x="25" y="19" width="2" height="7" xoffset="0" yoffset="1" xadvance="3"/>
        <char id="124" x="28" y="19" width="1" height="7" xoffset="1" yoffset="1" xadvance="4"/>
        <char id="81" x="30" y="19" width="5" height="6" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="163" x="36" y="19" width="5" height="6" xoffset="0" yoffset="1" xadvance="6"/>
        <char id="177" x="42" y="19" width="5" height="6" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="181" x="48" y="19" width="5" height="6" xoffset="0" yoffset="3" xadvance="6"/>
        <char id="103" x="54" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="112" x="59" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="113" x="64" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="121" x="69" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="162" x="74" y="19" width="4" height="6" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="228" x="79" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
        <char id="229" x="84" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
        <char id="231" x="89" y="19" width="4" height="6" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="240" x="94" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
        <char id="246" x="99" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
        <char id="252" x="104" y="19" width="4" height="6" xoffset="0" yoffset="1" xadvance="5"/>
        <char id="238" x="109" y="19" width="3" height="6" xoffset="-1" yoffset="1" xadvance="2"/>
        <char id="59" x="113" y="19" width="2" height="6" xoffset="0" yoffset="3" xadvance="4"/>
        <char id="236" x="116" y="19" width="2" height="6" xoffset="-1" yoffset="1" xadvance="2"/>
        <char id="237" x="119" y="19" width="2" height="6" xoffset="0" yoffset="1" xadvance="2"/>
        <char id="198" x="1" y="27" width="9" height="5" xoffset="0" yoffset="2" xadvance="10"/>
        <char id="190" x="11" y="27" width="8" height="5" xoffset="0" yoffset="2" xadvance="9"/>
        <char id="87" x="20" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
        <char id="188" x="28" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
        <char id="189" x="36" y="27" width="7" height="5" xoffset="0" yoffset="2" xadvance="8"/>
        <char id="38" x="44" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
        <char id="164" x="51" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
        <char id="208" x="58" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
        <char id="8364" x="65" y="27" width="6" height="5" xoffset="0" yoffset="2" xadvance="7"/>
        <char id="65" x="72" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="66" x="78" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="67" x="84" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="68" x="90" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="69" x="96" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="70" x="102" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="71" x="108" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="72" x="114" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="75" x="120" y="27" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="77" x="1" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="78" x="7" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="79" x="13" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="80" x="19" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="82" x="25" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="83" x="31" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="84" x="37" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="85" x="43" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="86" x="49" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="88" x="55" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="89" x="61" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="90" x="67" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="50" x="73" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="51" x="79" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="52" x="85" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="53" x="91" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="54" x="97" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="56" x="103" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="57" x="109" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="48" x="115" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="47" x="121" y="33" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="64" x="1" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="92" x="7" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="37" x="13" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="43" x="19" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="35" x="25" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="42" x="31" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="165" x="37" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="169" x="43" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="174" x="49" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="182" x="55" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="216" x="61" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="247" x="67" y="39" width="5" height="5" xoffset="0" yoffset="2" xadvance="6"/>
        <char id="74" x="73" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="76" x="78" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="98" x="83" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="100" x="88" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="104" x="93" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="107" x="98" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="55" x="103" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="63" x="108" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="191" x="113" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="222" x="118" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="223" x="123" y="39" width="4" height="5" xoffset="0" yoffset="2" xadvance="5"/>
        <char id="116" x="1" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="60" x="5" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="62" x="9" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="170" x="13" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="186" x="17" y="45" width="3" height="5" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="239" x="21" y="45" width="3" height="5" xoffset="-1" yoffset="2" xadvance="2"/>
        <char id="102" x="25" y="45" width="2" height="5" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="49" x="28" y="45" width="2" height="5" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="73" x="31" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="105" x="33" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="108" x="35" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="33" x="37" y="45" width="1" height="5" xoffset="1" yoffset="2" xadvance="3"/>
        <char id="161" x="39" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="166" x="41" y="45" width="1" height="5" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="109" x="43" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
        <char id="119" x="51" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
        <char id="230" x="59" y="45" width="7" height="4" xoffset="0" yoffset="3" xadvance="8"/>
        <char id="97" x="67" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="99" x="72" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="101" x="77" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="110" x="82" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="111" x="87" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="115" x="92" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="117" x="97" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="118" x="102" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="120" x="107" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="122" x="112" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="215" x="117" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="248" x="122" y="45" width="4" height="4" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="114" x="1" y="51" width="3" height="4" xoffset="0" yoffset="3" xadvance="4"/>
        <char id="178" x="5" y="51" width="3" height="4" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="179" x="9" y="51" width="3" height="4" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="185" x="13" y="51" width="1" height="4" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="61" x="15" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
        <char id="171" x="21" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
        <char id="172" x="27" y="51" width="5" height="3" xoffset="0" yoffset="4" xadvance="6"/>
        <char id="187" x="33" y="51" width="5" height="3" xoffset="0" yoffset="3" xadvance="6"/>
        <char id="176" x="39" y="51" width="3" height="3" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="44" x="43" y="51" width="2" height="3" xoffset="0" yoffset="6" xadvance="3"/>
        <char id="58" x="46" y="51" width="1" height="3" xoffset="1" yoffset="3" xadvance="4"/>
        <char id="94" x="48" y="51" width="4" height="2" xoffset="-1" yoffset="2" xadvance="4"/>
        <char id="126" x="53" y="51" width="4" height="2" xoffset="0" yoffset="3" xadvance="5"/>
        <char id="34" x="58" y="51" width="3" height="2" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="96" x="62" y="51" width="2" height="2" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="180" x="65" y="51" width="2" height="2" xoffset="0" yoffset="2" xadvance="3"/>
        <char id="184" x="68" y="51" width="2" height="2" xoffset="0" yoffset="7" xadvance="3"/>
        <char id="39" x="71" y="51" width="1" height="2" xoffset="0" yoffset="2" xadvance="2"/>
        <char id="95" x="73" y="51" width="5" height="1" xoffset="0" yoffset="7" xadvance="6"/>
        <char id="45" x="79" y="51" width="4" height="1" xoffset="0" yoffset="4" xadvance="5"/>
        <char id="173" x="84" y="51" width="4" height="1" xoffset="0" yoffset="4" xadvance="5"/>
        <char id="168" x="89" y="51" width="3" height="1" xoffset="1" yoffset="2" xadvance="5"/>
        <char id="175" x="93" y="51" width="3" height="1" xoffset="0" yoffset="2" xadvance="4"/>
        <char id="46" x="97" y="51" width="1" height="1" xoffset="0" yoffset="6" xadvance="2"/>
        <char id="183" x="99" y="51" width="1" height="1" xoffset="0" yoffset="4" xadvance="2"/>
        <char id="32" x="6" y="56" width="0" height="0" xoffset="0" yoffset="127" xadvance="3"/>
      </chars>
    </font>');
    
    public static var texture(get, never):Texture;
    private static function get_texture():Texture
    {
        var bitmapData:BitmapData = getBitmapData();
        //var format:String = Context3DTextureFormat.BGRA_PACKED;
        //var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, 1, format);
        var texture:Texture = Texture.fromBitmapData(bitmapData, false);
        bitmapData.dispose();
        bitmapData = null;

        texture.root.onRestore = function():Void
        {
            bitmapData = getBitmapData();
            texture.root.uploadBitmapData(bitmapData);
            bitmapData.dispose();
            bitmapData = null;
        };

        return texture;
    }

    private static function getBitmapData():BitmapData
    {
        var bmpData:BitmapData = new BitmapData(BITMAP_WIDTH, BITMAP_HEIGHT);
        var bmpBytes:ByteArray = new ByteArray();
        var length:Int = BITMAP_DATA.length;

        bmpBytes.endian = BIG_ENDIAN;

        for (i in 0...length)
            bmpBytes.writeUnsignedInt(BITMAP_DATA[i]);

        bmpBytes.uncompress();
        bmpData.setPixels(new Rectangle(0, 0, BITMAP_WIDTH, BITMAP_HEIGHT), bmpBytes);
        bmpBytes.clear();

        return bmpData;
    }
    
    public static var xml(get, never):Xml;
    private static function get_xml():Xml
    {
        // var xml:XML;
        // var xmlBytes:ByteArray = new ByteArray();
        // var length:UInt = XML_DATA.length;

        // for (i in 0...length)
        //     xmlBytes.writeUnsignedInt(XML_DATA[i]);

        // xmlBytes.uncompress();
        // xml = XML(xmlBytes.readUTF());
        // xmlBytes.clear();

        // return xml;
        return XML_DATA;
    }
}