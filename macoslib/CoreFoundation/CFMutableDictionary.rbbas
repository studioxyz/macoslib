	#tag Class	Class CFMutableDictionary	Inherits CFDictionary		#tag Method, Flags = &h0			Sub Constructor()			  #if targetMacOS			    soft declare function CFDictionaryCreateMutable lib CarbonFramework (allocator as Ptr, capacity as Integer, keyCallbacks as Ptr, valueCallbacks as Ptr) as Ptr			    			    // !TT says: no need for this, we can simply pass nil instead:			    'const kCFTypeDictionaryKeyCallBacks = "kCFTypeDictionaryKeyCallBacks"			    'const kCFTypeDictionaryValueCallBacks = "kCFTypeDictionaryValueCallBacks"			    			    me.Adopt CFDictionaryCreateMutable(nil, 0, nil, nil), true 'me.DefaultCallbacks(kCFTypeDictionaryKeyCallBacks), me.DefaultCallbacks(kCFTypeDictionaryValueCallBacks))			  #endif			  			End Sub		#tag EndMethod		#tag Method, Flags = &h21			Private Function DefaultCallbacks(name as String) As Ptr			  return CFBundle.CarbonFramework.DataPointer(name)			End Function		#tag EndMethod		#tag Method, Flags = &h0			Sub Constructor(theDictionary as CFDictionary)			  #if TargetMacOS			    soft declare function CFDictionaryCreateMutableCopy lib CarbonFramework (allocator as Ptr, capacity as Integer, theDict as Ptr) as Ptr			    			    if not (theDictionary is nil) then			      me.Adopt CFDictionaryCreateMutableCopy(nil, 0, me.Reference), true			    end if			  #endif			End Sub		#tag EndMethod		#tag Method, Flags = &h0			Sub Clear()			  #if targetMacOS			    soft declare sub CFDictionaryRemoveAllValues lib CarbonFramework (theDict as Ptr)			    			    if not me.IsNULL then			      CFDictionaryRemoveAllValues me.Reference			    end if			  #endif			End Sub		#tag EndMethod		#tag Method, Flags = &h0			Sub Remove(key as CFType)			  #if targetMacOS			    //this function would be more accurately named "RemoveIfPresent"; if the key is not found, it just returns			    soft declare sub CFDictionaryRemoveValue lib CarbonFramework (theDict as ptr, key as Ptr)			    			    if not me.IsNULL and not (key is nil) then			      CFDictionaryRemoveValue me.Reference, key.Reference			    end if			  #endif			  			  			End Sub		#tag EndMethod		#tag Method, Flags = &h0			Sub Value(key as CFType, assigns value as CFType)			  #if targetMacOS			    soft declare sub CFDictionarySetValue lib CarbonFramework (theDict as Ptr, key as Ptr, value as Ptr)			    			    if not me.IsNULL and not (key is nil) and not (value is nil) then			      CFDictionarySetValue me.Reference, key.Reference, value.Reference			    end if			  #endif			  			  			End Sub		#tag EndMethod		#tag ViewBehavior			#tag ViewProperty				Name="Count"				Group="Behavior"				InitialValue="0"				Type="Integer"				InheritedFrom="CFDictionary"			#tag EndViewProperty			#tag ViewProperty				Name="Name"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Index"				Visible=true				Group="ID"				InitialValue="-2147483648"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Super"				Visible=true				Group="ID"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Left"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty			#tag ViewProperty				Name="Top"				Visible=true				Group="Position"				InitialValue="0"				InheritedFrom="Object"			#tag EndViewProperty		#tag EndViewBehavior	End Class	#tag EndClass