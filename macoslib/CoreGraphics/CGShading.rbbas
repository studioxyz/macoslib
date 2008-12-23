	#tag Class	Class CGShading	Inherits CFType		#tag Event			Function ClassID() As UInt32			  return me.ClassID			End Function		#tag EndEvent		#tag Method, Flags = &h0			 Shared Function ClassID() As UInt32			  #if targetMacOS			    soft declare function CGShadingGetTypeID lib CarbonFramework () as UInt32			    			    return CGShadingGetTypeID			  #endif			End Function		#tag EndMethod		#tag Method, Flags = &h0			Sub Constructor(colorspace as CGColorSpace, startPt as CGPoint, endPt as CGPoint, callbacks as CGFunction, extendStart as Boolean, extendEnd as Boolean)			  if colorspace = nil then			    return			  end if			  if callbacks = nil then			    return			  end if			  			  #if targetMacOS			    soft declare function CGShadingCreateAxial lib CarbonFramework (colorspace as Ptr, start as CGPoint, endpt as CGPoint, func as Ptr, extendStart as Boolean, extendEnd as Boolean) as Ptr			    			    me.Adopt CGShadingCreateAxial(colorspace, startPt, endPt, callbacks, extendStart, extendEnd), true			    me.ShadingFunction = callbacks			  #endif			End Sub		#tag EndMethod		#tag Method, Flags = &h0			Sub Constructor(colorspace as CGColorSpace, startPt as CGPoint, startRadius as Double, endPt as CGPoint, endRadius as Double, callbacks as CGFunction, extendStart as Boolean, extendEnd as Boolean)			  if colorspace = nil then			    return			  end if			  if callbacks = nil then			    return			  end if			  			  #if targetMacOS			    soft declare function CGShadingCreateRadial lib CarbonFramework (colorspace as Ptr, start as CGPoint, startRadius as Single, endPt as CGPoint, endRadius as Single, func as Ptr, extendStart as Boolean, extendEnd as Boolean) as Ptr			    			    me.Adopt CGShadingCreateRadial(colorspace, startPt, startRadius, endPt, endRadius, callbacks, extendStart, extendEnd), true			    me.ShadingFunction = callbacks			  #endif			End Sub		#tag EndMethod		#tag Property, Flags = &h21			Private ShadingFunction As CGFunction		#tag EndProperty		#tag ViewBehavior			#tag ViewProperty				Name="Name"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Index"				Visible=true				Group="ID"				InitialValue="-2147483648"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Super"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Left"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Top"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty		#tag EndViewBehavior	End Class	#tag EndClass