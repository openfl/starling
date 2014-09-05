package starling.containers;


    import starling.core.Starling;
    import starling.core.RenderSupport;
    
    import openfl.display.Sprite;
    import openfl.display3D.Context3D;
    import openfl.display3D.Context3DTextureFormat;
    import openfl.display3D.textures.Texture;
    //import openfl.events.ContextMenuEvent;
    import openfl.events.Event;
    import openfl.geom.Point;
    import openfl.geom.Rectangle;
    import openfl.geom.Transform;
    import openfl.net.URLRequest;
    import openfl.filters.BitmapFilter;
    //import openfl.net.navigateToURL;
    //import openfl.ui.ContextMenu;
    //import openfl.ui.ContextMenuItem;
    //import openfl.utils.getTimer;

    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.events.Stage3DEvent;
    
    import openfl.Lib;
    import openfl.errors.Error;

    //use namespace arcane;
    
    class View2D extends Sprite
    {
        var _width:Float;
        var _height:Float;

        var _time:UInt;
        var _deltaTime:UInt;
        
        var _starling:Starling;
        var _addedToStage:Bool;
        
        var _forceSoftware:Bool;

        var _parentIsStage:Bool;
        
        var _stage3DProxy:Stage3DProxy;
        var _backBufferInvalid:Bool;
        var _antiAlias:UInt;
        
        var _rightClickMenuEnabled:Bool;
        var _sourceURL:String;
        //var _menu0:ContextMenuItem;
        //var _menu1:ContextMenuItem;
        //var _ViewContextMenu:ContextMenu;
        var _shareContext:Bool;

        var _profile:String;
        var _callbackMethod:Event -> Void;
        
        // private function viewSource(e:ContextMenuEvent):Void
        // {
        //  var request:URLRequest = new URLRequest(_sourceURL);
        //  try {
        //      Lib.getURL(request, "_blank");
        //  } catch (error:Error) {
                
        //  }
        // }
        
        // private function visitWebsite(e:ContextMenuEvent):Void
        // {
        //  var url:String = Away3D.WEBSITE_URL;
        //  var request:URLRequest = new URLRequest(url);
        //  try {
        //      Lib.getURL(request);
        //  } catch (error:Error) {
                
        //  }
        // }
        
        // private function initRightClickMenu():Void
        // {
        //  _menu0 = new ContextMenuItem("Away3D.com\tv" + Away3D.MAJOR_VERSION + "." + Away3D.MINOR_VERSION + "." + Away3D.REVISION, true, true, true);
        //  _menu1 = new ContextMenuItem("View Source", true, true, true);
        //  _menu0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, visitWebsite);
        //  _menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, viewSource);
        //  _ViewContextMenu = new ContextMenu();
            
        //  updateRightClickMenu();
        // }
        
        // private function updateRightClickMenu():Void
        // {
        //  if (_rightClickMenuEnabled)
        //      _ViewContextMenu.customItems = _sourceURL!="" ? [_menu0, _menu1] : [_menu0];
        //  else
        //      _ViewContextMenu.customItems = [];
            
        //  //TODO Not sure atm why contextMenu is not avaialble - maybe not in OpenFL
        //  //contextMenu = _ViewContextMenu;
        // }
        
        public function new(starling:Starling = null, forceSoftware:Bool = false, profile:String = "baseline")
        {
            _width = 0;
            _height = 0;

            super();

            _time = 0;
            
            _backBufferInvalid = true;
                
            _rightClickMenuEnabled = true;
            _shareContext = false;

            _profile = profile;
            _starling = starling;
            _forceSoftware = forceSoftware;

            //_touch3DManager.view = this;
            //_touch3DManager.enableTouchListeners(this);
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
            addEventListener(Event.ADDED, onAdded, false, 0, true);

            //initRightClickMenu();
        }

        
        // public var rightClickMenuEnabled(get, set) : Bool;
        
        // public function get_rightClickMenuEnabled() : Bool
        // {
        //  return _rightClickMenuEnabled;
        // }
        
        // public function set_rightClickMenuEnabled(val:Bool) : Bool
        // {
        //  _rightClickMenuEnabled = val;
            
        //  updateRightClickMenu();
        //  return _rightClickMenuEnabled;
        // }
        
        public var stage3DProxy(get, set) : Stage3DProxy;
        
        public function get_stage3DProxy() : Stage3DProxy
        {
            return _stage3DProxy;
        }
        
        public function set_stage3DProxy(stage3DProxy:Stage3DProxy) : Stage3DProxy
        {   
            _stage3DProxy = stage3DProxy;
            
            _backBufferInvalid = true;
            return _stage3DProxy;
        }

        
        /**
         * The starling instance used to draw the scene.
         */
        public var starlingPtr(get, set) : Starling;
        public function get_starlingPtr() : Starling
        {
            return _starling;
        }
        
        public function set_starlingPtr(value:Starling) : Starling
        {
            if (_starling != null)
                _starling.dispose();
            _starling = value;
            return _starling;
        }
        
        // todo: probably temporary:
        /**
         * The amount of milliseconds the last render call took
         */
        public var deltaTime(get, null) : UInt;
        public function get_deltaTime() : UInt
        {
            return _deltaTime;
        }
        
        #if flash

        /**
         * Not supported. Use filters3d instead.
         */
        @:getter(filters)
        public function get_filters() : Array<Dynamic>
        {
            throw new Error("filters is not supported in View2D. Use filters3d instead.");
            return null;
        }
        
        /**
         * Not supported. Use filters3d instead.
         */
        @:setter(filters)
        public function set_filters(value:Array<Dynamic>) : Void
        {
            throw new Error("filters is not supported in View2D. Use filters3d instead.");
        }
        
        /**
         * The width of the viewport. When software rendering is used, this is limited by the
         * platform to 2048 pixels.
         */
        @:getter(width)
        public function get_width() : Float
        {
            return _width;
        }

        @:setter(width)
        public function set_width(value:Float) : Void
        {
            // Backbuffer limitation in software mode. See comment in updateBackBuffer()
            if (_stage3DProxy!=null && _stage3DProxy.usesSoftwareRendering && value > 2048)
                value = 2048;
            
            if (_width == value)
                return;

            _width = value;
        }

        /**
         * The height of the viewport. When software rendering is used, this is limited by the
         * platform to 2048 pixels.
         */
        @:getter(height)
        public function get_height() : Float
        {
            return _height;
        }

        @:setter(height)
        public function set_height(value:Float) : Void
        {
            // Backbuffer limitation in software mode. See comment in updateBackBuffer()
            if (_stage3DProxy!=null && _stage3DProxy.usesSoftwareRendering && value > 2048)
                value = 2048;
            
            if (_height == value)
                return;
            
            _height = value;
            return;
        }


        #else
        
        // /**
        //  * Not supported. Use filters3d instead.
        //  */
        // override public function get_filters() : Array<Dynamic>
        // {
        //     throw new Error("filters is not supported in View2D. Use filters3d instead.");
        //     return null;
        // }
        
        // /**
        //  * Not supported. Use filters3d instead.
        //  */
        // override public function set_filters(value:Array<Dynamic>) : Array<Dynamic>
        // {
        //     throw new Error("filters is not supported in View2D. Use filters3d instead.");
        //     return null;
        // }

        /**
         * The width of the viewport. When software rendering is used, this is limited by the
         * platform to 2048 pixels.
         */
        override public function get_width() : Float
        {
            return _width;
        }

        override public function set_width(value:Float) : Float
        {
            // Backbuffer limitation in software mode. See comment in updateBackBuffer()
            if (_stage3DProxy!=null && _stage3DProxy.usesSoftwareRendering && value > 2048)
                value = 2048;
            
            if (_width == value)
                return value;

            _width = value;
            // TODO:
            if (_starling != null)
            {
                var viewPort:Rectangle = _starling.viewPort;
                viewPort.width = _width;
                _starling.viewPort = viewPort;
            }
            
            
            _backBufferInvalid = true;
            return value;
        }

        /**
         * The height of the viewport. When software rendering is used, this is limited by the
         * platform to 2048 pixels.
         */
        override public function get_height() : Float
        {
            return _height;
        }

        override public function set_height(value:Float) : Float
        {
            // Backbuffer limitation in software mode. See comment in updateBackBuffer()
            if (_stage3DProxy!=null && _stage3DProxy.usesSoftwareRendering && value > 2048)
                value = 2048;
            
            if (_height == value)
                return value;

            _height = value;
            if (_starling != null)
            {
                var viewPort:Rectangle = _starling.viewPort;
                viewPort.height = _height;
                _starling.viewPort = viewPort;
            }
            
            
            _backBufferInvalid = true;
            return value;
        }

        override public function set_visible(value:Bool) : Bool
        {
            super.visible = value;
            
            if (_stage3DProxy!=null && !_shareContext)
                _stage3DProxy.visible = value;
            return value;
        }

        #end      
        
        /**
         * The amount of anti-aliasing to be used.
         */
        public var antiAlias(get, set) : UInt;
        public function get_antiAlias() : UInt
        {
            return _antiAlias;
        }
        
        public function set_antiAlias(value:UInt) : UInt
        {
            _antiAlias = value;
            _starling.antiAliasing = value;
            
            _backBufferInvalid = true;
            return _antiAlias;
        }
        
        /**
         * Defers control of Context3D clear() and present() calls to Stage3DProxy, enabling multiple Stage3D frameworks
         * to share the same Context3D object.
         */
        public var shareContext(get, set) : Bool;
        public function get_shareContext() : Bool
        {
            return _shareContext;
        }
        
        public function set_shareContext(value:Bool) : Bool
        {
            if (_shareContext == value)
                return value;
            
            _shareContext = value;
            return value;
        }
        
        /**
         * Updates the backbuffer dimensions.
         */
        private function updateBackBuffer():Void
        {
            // No reason trying to configure back buffer if there is no context available.
            // Doing this anyway (and relying on _stage3DProxy to cache width/height for 
            // context does get available) means usesSoftwareRendering won't be reliable.
            if (_stage3DProxy.context3D!=null && !_shareContext) {
                if (_width>0 && _height>0) {
                    // Backbuffers are limited to 2048x2048 in software mode and
                    // trying to configure the backbuffer to be bigger than that
                    // will throw an error. Capping the value is a graceful way of
                    // avoiding runtime exceptions for developers who are unable
                    // to test their Away3D implementation on screens that are 
                    // large enough for this error to ever occur.
                    if (_stage3DProxy.usesSoftwareRendering) {
                        // Even though these checks where already made in the width
                        // and height setters, at that point we couldn't be sure that
                        // the context had even been retrieved and the software flag
                        // thus be reliable. Make checks again.
                        if (_width > 2048)
                            _width = 2048;
                        if (_height > 2048)
                            _height = 2048;
                    }
                    
                    _stage3DProxy.configureBackBuffer(Std.int(_width), Std.int(_height), _antiAlias, true);
                    _backBufferInvalid = false;
                } else {
                    width = stage.stageWidth;
                    height = stage.stageHeight;
                }
            }
        }
        
        /**
         * Defines the enter frame/render method to be used for rendering across platforms
         *
         */
        public function setRenderCallback(func : Event -> Void) : Void {
            if (_stage3DProxy != null)
                _stage3DProxy.setRenderCallback(func);

            _callbackMethod = func;
        }


        /**
         * Defines a source url string that can be accessed though a View Source option in the right-click menu.
         *
         * Requires the stats panel to be enabled.
         *
         * @param    url        The url to the source files.
         */
        // public function addSourceURL(url:String):Void
        // {
        //  _sourceURL = url;
            
        //  updateRightClickMenu();
        // }
        
        /**
         * Renders the view.
         */
        public function render():Void
        {
            
            //if context3D has Disposed by the OS,don't render at this frame
            if (!stage3DProxy.recoverFromDisposal()) {
                _backBufferInvalid = true;
                return;
            }
            
            // reset or update render settings
            if (_backBufferInvalid)
                updateBackBuffer();
            
            updateTime();

            //_touch3DManager.updateCollider();

            RenderSupport._clear();
            _starling.render();
            
            if (!_shareContext) {
                stage3DProxy.present();
                
                // fire collected mouse events
                //_touch3DManager.fireTouchEvents();
            }
            
            // register that a view has been rendered
            stage3DProxy.bufferClear = false;
        }

        
        private function updateTime():Void
        {
            var time:UInt = Lib.getTimer();
            if (_time == 0)
                _time = time;
            _deltaTime = time - _time;
            _time = time;
        }

        
        /**
         * Disposes all memory occupied by the view. This will also dispose the renderer.
         */
        public function dispose():Void
        {
            if (!shareContext)
                _stage3DProxy.dispose();
            _starling.dispose();
            
            //_touch3DManager.disableTouchListeners(this);
            //_touch3DManager.dispose();

            //_touch3DManager = null;
            _stage3DProxy = null;
            _starling = null;
        }


        /**
         * When added to the stage, retrieve a Stage3D instance
         */
        private function onAddedToStage(event:Event):Void
        {
            if (_addedToStage)
                return;
            
            _addedToStage = true;
            
            if (_stage3DProxy==null) {
                _stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy(_forceSoftware, _profile);
                if (_callbackMethod!=null) {
                    _stage3DProxy.setRenderCallback(_callbackMethod);
                }       
            }
            
            //default wiidth/height to stageWidth/stageHeight
            if (_width == 0)
                width = stage.stageWidth;
            if (_height == 0)
                height = stage.stageHeight;
        }
        
        private function onAdded(event:Event):Void
        {
            _parentIsStage = (parent == stage);
        }
        
        // dead ends:
        // override public function set_z(value:Float) : Float
        // {
        //  return value;
        // }
        
        // override public function set_scaleZ(value:Float) : Float
        // {
        //  return value;
        // }
        
        //override public function set_rotation(value:Float) : Float
        //{
        //    return value;
        //}
        
        // override public function set_rotationX(value:Float) : Float
        // {
        //  return value;
        // }
        
        // override public function set_rotationY(value:Float) : Float
        // {
        //  return value;
        // }
        
        // override public function set_rotationZ(value:Float) : Float
        // {
        //  return value;
        // }
        
        // override public function set_transform(value:Transform) : Transform
        // {
        //     return value;
        // }
        
        // override public function set_scaleX(value:Float) : Float
        // {
        //     return value;
        // }
        
        // override public function set_scaleY(value:Float) : Float
        // {
        //     return value;
        // }
    }

