#tag Class
Protected Class MacPListBrowser
	#tag Method, Flags = &h0
		Sub AppendChild(value As Variant)
		  // Appends a child to an array.
		  
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotArray( "AppendChild" )
		    
		    dim newIndex as integer = me.Count
		    dim v() as Variant = zValue
		    redim v( newIndex )
		    zValue = v
		    me.Child( newIndex ) = value // Do it this way so we don't have to recheck the value
		    
		  #else
		    
		    #pragma unused value
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ArrayValues() As MacPListBrowser()
		  dim r() As MacPListBrowser
		  
		  #if TargetMacOS
		    
		    if zValueType <> ValueType.IsArray then pRaiseError "ArrayValues can only be used with an array."
		    
		    dim v() as Variant = zValue
		    dim lastIndex as integer = v.Ubound
		    redim r( lastIndex )
		    for i as integer = 0 to lastIndex
		      r( i ) = v( i )
		    next
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(index As Integer) As MacPListBrowser
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotArray( "Child with index" )
		    
		    dim v() as Variant = zValue
		    return v( index )
		    
		  #else
		    
		    #pragma unused index
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(index As Integer, Assigns value As Variant)
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotArray( "Child with index" )
		    
		    if not pIsValidValue( value ) then
		      pRaiseError "Only a valid type (dictionary, array, string, number, boolean, date, or data) can be assigned to an array."
		    end if
		    
		    dim v() as variant = zValue
		    v( index ) = new MacPListBrowser( value, self, index )
		    
		  #else
		    
		    #pragma unused index
		    #pragma unused value
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(k As String) As MacPListBrowser
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotDictionary( "Child with key" )
		    
		    dim dict as Dictionary = zValue
		    return dict.Value( k )
		    
		  #else
		    
		    #pragma unused key
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(k As String, Assigns value As Variant)
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotDictionary( "Child with key" )
		    
		    if k.LenB = 0 then pRaiseError( "Can't assign an empty key." )
		    
		    if not pIsValidValue( value ) then
		      pRaiseError "Only a valid type (dictionary, array, string, number, boolean, date, or data) can be assigned to a dictionary."
		    end if
		    
		    dim dict as Dictionary = zValue
		    dict.Value( k ) = new MacPListBrowser( value, self, k )
		    
		  #else
		    
		    #pragma unused index
		    #pragma unused value
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChildrenContainingKey(findKey As String, recursive As Boolean = True) As MacPListBrowser()
		  // Returns an array of children whose key contains the given string.
		  // If recursive, will examine every child dictionary too.
		  
		  dim r() as MacPListBrowser
		  
		  #if TargetMacOS
		    
		    if recursive then
		      pRaiseErrorIfNotArrayOrDictionary( "ChildrenContainingKey" )
		    else
		      pRaiseErrorIfNotDictionary( "ChildrenContainingKey, when recursive is ""false""," )
		    end if
		    
		    pChildrenContainingKey( findKey, recursive, r )
		    
		  #else
		    
		    #pragma unused findKey
		    #pragma unused recursive
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChildrenKeys() As String()
		  dim r() as string
		  
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotDictionary( "ChildrenKeys" )
		    
		    dim dict as Dictionary = zValue
		    dim keys() as variant = dict.Keys
		    redim r( keys.Ubound )
		    for i as integer = 0 to keys.Ubound
		      r( i ) = keys( i ).StringValue
		    next
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(rootType As ValueType = ValueType.IsDictionary)
		  #if TargetMacOS
		    
		    dim v as Variant
		    
		    select case rootType
		    case ValueType.IsDictionary
		      v = new Dictionary
		      
		    case ValueType.IsArray
		      dim arr() as Variant
		      v = arr
		      
		    else
		      pRaiseError "If the root value is not an array or dictionary, specify the initial value to use instead."
		      
		    end
		    
		    me.Constructor( v, nil, nil )
		    
		  #else
		    
		    pRaiseError "This class can only be used in the MacOS.
		    
		    #pragma unused myValue
		    #pragma unused myParent
		    #pragma unused myParentIndex
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(myValue As Variant, myParent As MacPListBrowser = nil, myParentIndex As Variant = nil)
		  // Private constuctor for children of a parent.
		  // From a public call, myValue cannot be a MacPListBrowser, so if it is, that had to come from a parent.
		  
		  #if TargetMacOS
		    
		    if myValue IsA MacPListBrowser then
		      zValue = MacPListBrowser( myValue ).VariantValue
		      
		      // See if it's a FolderItem that exists
		    elseif myValue IsA FolderItem then
		      dim f as FolderItem = myValue
		      if f.Exists then
		        dim plist as CoreFoundation.CFPropertyList = CoreFoundation.CFType.CreateFromPListFile( f, CoreFoundation.kCFPropertyListMutableContainersAndLeaves )
		        if plist <> nil then
		          myValue = plist.VariantValue
		        end if
		      end if
		      
		    elseif not pIsValidValue( myValue ) then
		      pRaiseError( "You can only create a MacPListBrowser from another MacPListBrowser, a FolderItem that points to a plist or string, " + _
		      "or from a dictionary, array, string, number, date, boolean, or MemoryBlock." )
		      
		    end if
		    
		    me.VariantValue = myValue // Convert it o MacPListBrowser objects as needed
		    
		    if myParent <> nil then
		      dim w as new WeakRef( myParent )
		      zParent = w
		      zParentIndex = myParentIndex
		    end if
		    
		  #else
		    
		    pRaiseError "This class can only be used in the MacOS.
		    
		    #pragma unused myValue
		    #pragma unused myParent
		    #pragma unused myParentIndex
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  if zValueType = ValueType.IsArray then
		    dim v() as variant = zValue
		    return v.UBound + 1
		  elseif zValueType = ValueType.IsDictionary then
		    dim dict as Dictionary = zValue
		    return dict.Count
		  else
		    return -1 // Not an array or dictionary
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CreateFromPListFile(f As FolderItem) As MacPListBrowser
		  // Convenience method, here just for clarity.
		  // Passing a folderitem to the constructor will do the same thing.
		  
		  return new MacPListBrowser( f )
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Function CreateFromPListString(s As String) As MacPListBrowser
		  // Returns a MacPListBrowser from a plist string.
		  // Could have put this into the contructor, but don't want to make assumptions about
		  // what the developer is trying to do.
		  // Will return nil if the string can't be converted, or just the original string if it's not a plist.
		  
		  dim r as MacPListBrowser
		  
		  #if TargetMacOS
		    
		    dim plist as CoreFoundation.CFPropertyList = CFType.CreateFromPListString( s, CoreFoundation.kCFPropertyListMutableContainersAndLeaves )
		    if plist <> nil then
		      dim v as variant = plist.VariantValue
		      r = new MacPListBrowser( v )
		    end if
		    
		  #else
		    
		    #pragma unused s
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasKey(k As String) As Boolean
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotDictionary( "HasKey" )
		    dim dict as Dictionary = zValue
		    return dict.HasKey( k )
		    
		  #else
		    
		    #pragma unused k
		    
		  #endif
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pArrayType() As ValueType
		  dim r as ValueType = ValueType.IsUnknown
		  
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotArray( "ArrayType" )
		    
		    if me.Count <> 0 then
		      r = pValueTypeOfVariant( me.Child( 0 ).VariantValue )
		    end if
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub pChildrenContainingKey(findKey As String, recursive As Boolean, appendTo() As MacPListBrowser)
		  // Recursive method used to fill in the appendTo array with children matching the given key
		  
		  #if TargetMacOS
		    
		    if zValueType = ValueType.IsDictionary then
		      
		      dim k() as String = me.ChildrenKeys
		      for each thisKey as string in k
		        if thisKey.InStr( findKey ) <> 0 then appendTo.Append( me.Child( thisKey ) )
		        if recursive then
		          dim thisChild as MacPListBrowser = me.Child( thisKey )
		          thisChild.pChildrenContainingKey( findKey, recursive, appendTo )
		        end if
		      next
		      
		    elseif recursive and zValueType = ValueType.IsArray then
		      
		      dim lastIndex as integer = me.Count - 1
		      for i as integer = 0 to lastIndex
		        dim thisChild as MacPListBrowser = me.Child( i )
		        thisChild.pChildrenContainingKey( findKey, recursive, appendTo )
		      next
		      
		    end if
		    
		  #else
		    
		    #pragma unused findKey
		    #pragma unused recursive
		    #pragma unused appendTo
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pIsValidValue(ByRef value As Variant) As Boolean
		  // Validates that the value given is acceptible.
		  // Also changes value to the contents of the given object as needed.
		  // MacPListBrowser will be changed to their value.
		  
		  dim r as boolean
		  
		  #if TargetMacOS
		    
		    if value IsA MacPListBrowser then
		      dim plist as MacPListBrowser = value
		      value = plist.VariantValue // Extract its value
		      r = true // Assumed true, else it couldn't have been created in the first place
		      
		    else
		      
		      dim theType as ValueType = pValueTypeOfVariant( value )
		      if theType <> ValueType.IsUnknown then r = true
		      
		    end if
		    
		  #else
		    
		    #pragma unused value
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pRaiseError(msg As String)
		  dim err as new RuntimeException
		  err.Message = msg
		  raise err
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pRaiseErrorIfNotArray(msg As String)
		  if zValueType <> ValueType.IsArray then
		    pRaiseError( msg + " can only be used with an array." )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pRaiseErrorIfNotArrayOrDictionary(msg As String)
		  if zValueType <> ValueType.IsArray and zValueType <> ValueType.IsDictionary then
		    pRaiseError( msg + " can only be used with an array or dictionary." )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pRaiseErrorIfNotDictionary(msg As String)
		  if zValueType <> ValueType.IsDictionary then
		    pRaiseError( msg + " can only be used with a dictionary." )
		  end if
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pSetValueFromArray(sourceArr() As Variant)
		  dim newArr() as Variant
		  redim newArr( sourceArr.Ubound )
		  for i as integer = 0 to sourceArr.Ubound
		    dim thisValue as Variant = sourceArr( i )
		    newArr( i ) = new MacPListBrowser( thisValue, self, i )
		  next
		  
		  zValue = newArr
		  zValueType = ValueType.IsArray
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub pSetValueFromDictionary(sourceDict As Dictionary)
		  dim k() as Variant = sourceDict.Keys
		  dim newDict as new Dictionary
		  for each thisKey as Variant in k
		    dim thisValue as Variant = sourceDict.Value( thisKey )
		    newDict.Value( thisKey ) = new MacPListBrowser( thisValue, self, thisKey.StringValue )
		  next
		  
		  zValue = newDict
		  zValueType = ValueType.IsDictionary
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pValueTypeFromVariantType(t As Integer) As ValueType
		  
		  select case t
		  case Variant.TypeNil
		    return ValueType.IsNil
		  case Variant.TypeInteger, Variant.TypeSingle, Variant.TypeDouble, Variant.TypeLong
		    return ValueType.IsNumber
		  case Variant.TypeString
		    return ValueType.IsString
		  case Variant.TypeDate
		    return ValueType.IsDate
		  case Variant.TypeBoolean
		    return ValueType.IsBoolean
		  else
		    return ValueType.IsUnknown // Really shouldn't happen
		  end
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function pValueTypeOfVariant(value As Variant) As ValueType
		  dim v as variant = value
		  
		  if v.IsArray then
		    return ValueType.IsArray
		  else
		    
		    select case v.Type
		    case Variant.TypeNil
		      return ValueType.IsNil
		    case Variant.TypeObject
		      if v IsA Dictionary then
		        return ValueType.IsDictionary
		      elseif v.IsArray then
		        return ValueType.IsArray
		      elseif v IsA MemoryBlock then
		        return ValueType.IsData
		      else
		        return ValueType.IsUnknown
		      end if
		    case Variant.TypeInteger, Variant.TypeSingle, Variant.TypeDouble, Variant.TypeLong
		      return ValueType.IsNumber
		    case Variant.TypeString
		      return ValueType.IsString
		    case Variant.TypeDate
		      return ValueType.IsDate
		    case Variant.TypeBoolean
		      return ValueType.IsBoolean
		    else
		      return ValueType.IsUnknown // Really shouldn't happen
		    end
		  end if
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChild(index As Integer)
		  // Return a child with the given index.
		  
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotArray( "RemoveChild with index" )
		    
		    dim v() as variant = zValue
		    v.Remove index
		    
		  #else
		    
		    #pragma unused index
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveChild(k As String)
		  // Return a child with the given key.
		  
		  #if TargetMacOS
		    
		    pRaiseErrorIfNotDictionary( "RemoveChild with key" )
		    
		    if k.LenB = 0 then pRaiseError( "No key specified." )
		    
		    dim dict as Dictionary = zValue
		    dict.Remove k
		    
		  #else
		    
		    #pragma unused key
		    
		  #endif
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SaveToFile(f As FolderItem) As Boolean
		  dim r as boolean
		  
		  #if TargetMacOS
		    
		    if f <> nil then
		      dim cf as CoreFoundation.CFType = CoreFoundation.CFTypeFromVariant( VariantValue )
		      dim plist as CoreFoundation.CFPropertyList = CoreFoundation.CFPropertyList( cf )
		      r = plist.WriteToFile( f, true )
		    end if
		    
		  #else
		    
		    #pragma unused f
		    
		  #endif
		  
		  return r
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAsCFPropertyList() As CoreFoundation.CFPropertyList
		  #if TargetMacOS
		    
		    dim cf as CoreFoundation.CFType = CoreFoundation.CFTypeFromVariant( me.VariantValue )
		    return CoreFoundation.CFPropertyList( cf )
		    
		  #else
		    
		    return nil
		    
		  #endif
		  
		End Function
	#tag EndMethod


	#tag Note, Name = Legal
		This class was created by Kem Tekinay, MacTechnologies Consulting (ktekinay@mactechnologies.com).
		It is copyright ©2012, all rights reserved.
		
		You may use this class AS IS at your own risk for any purpose. The author does not warrant its use
		for any particular purpose and disavows any responsibility for bad design, poor execution,
		or any other faults.
		
		The author does not actively support this class, although comments and recommendations
		are welcome.
		
		You may modify code in this class as long as those modifications are clearly indicated
		via comments in the source code.
		
		You may distribute this class, modified or unmodified, as long as any modifications
		are clearly indicated, as noted above, and this copyright notice is not disturbed or removed.
		
		This class is distributed as part of, and is dependent on, the MacOSLib project.
	#tag EndNote

	#tag Note, Name = Usage
		
		This class is in ongoing development and is meant to make working with plists easier.
		Create a new instance by assigning like a dictionary or array to it:
		
		dim b1 as new MacPListBrowser( new Dictionary )
		
		dim a() as variant
		dim b2 as new MacPListBrowser( a )
		
		You can also use
		dim b3 as new MacPListBrowser()
		
		to start with an empty dictionary, or
		
		dim b4 as new MacPListBrowser( MacPListBrowser.ValueType.IsArray )
		
		to start with an empty array.
		
		You can also supply a string, date, number, memoryblock (for data), or boolean, although these are less useful.
		
		Finally, you can supply a plist as a string, a FolderItem that contains a plist, or another MacPListBrowser.
		
		You can extract the value of the plist by using VariantValue. If the value is an array or dictionary, you can use
		Child( index ) or Child( key ) respectively to get or assign the value of an element. These values are returns
		as MacPListBrowser instances.
	#tag EndNote


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetMacOS
			    
			    dim r as string
			    
			    dim p as MacPListBrowser = me.Parent
			    if p <> nil and p.Type = ValueType.IsDictionary then
			      r = zParentIndex.StringValue
			      
			    else
			      pRaiseError "This value doesn't appear to be part of a dictionary."
			      
			    end if
			    
			    return r
			    
			  #endif
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  #if TargetMacOS
			    
			    if value.LenB = 0 then pRaiseError( "Can't assign an empty key." )
			    
			    dim p as MacPListBrowser = me.Parent
			    if p <> nil and p.Type = ValueType.IsDictionary then
			      if p.HasKey( value ) then pRaiseError( "The key """ + value + """ already exists." )
			      
			      dim oldKey as string = zParentIndex.StringValue
			      dim v as MacPListBrowser = me // Save a reference, just in case
			      #pragma unused v
			      p.RemoveChild( oldKey )
			      p.Child( value ) = zValue // Assign it new
			      zParentIndex = value // Record the new key
			      
			    else // Not part of a dictionary
			      pRaiseError "This MacPListBrowser is not a value within a dictionary."
			    end if
			    
			  #else
			    
			    #pragma unused value
			    
			  #endif
			  
			End Set
		#tag EndSetter
		Key As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  if zParent is nil or zParent.Value is nil then
			    return nil
			  else
			    dim o as Object = zParent.Value
			    dim p as MacPListBrowser = MacPListBrowser( o )
			    return p
			  end if
			  
			End Get
		#tag EndGetter
		Parent As MacPlistBrowser
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return zValueType
			  
			End Get
		#tag EndGetter
		Type As ValueType
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  dim r as Variant
			  
			  #if TargetMacOS
			    
			    if zValueType = ValueType.IsArray then
			      dim sourceArr() as Variant = zValue
			      dim returnArr() as Variant
			      redim returnArr( sourceArr.Ubound )
			      for i as integer = 0 to sourceArr.Ubound
			        dim thisPlist as MacPListBrowser = sourceArr( i )
			        returnArr( i ) = thisPlist.VariantValue
			      next i
			      r = returnArr
			      
			    elseif zValueType = ValueType.IsDictionary then
			      dim sourceDict as Dictionary = zValue
			      dim returnDict as new Dictionary
			      dim k() as Variant = sourceDict.Keys
			      for each thisKey As Variant in k
			        dim thisPlist as MacPListBrowser = sourceDict.Value( thisKey )
			        returnDict.Value( thisKey ) = thisPlist.VariantValue
			      next
			      r = returnDict
			      
			    else
			      r = zValue
			      
			    end if
			    
			  #endif
			  
			  return r
			  
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  if not pIsValidValue( value ) then // Drills down into the value to get the real value (contents of a MacPLIstBrowser, if needed)
			    pRaiseError "This is not an acceptable type for a plist."
			  end if
			  
			  if value IsA Dictionary then
			    pSetValueFromDictionary( value )
			    
			  elseif value.IsArray then
			    dim v() as Variant = value
			    pSetValueFromArray( v )
			    
			  else
			    zValue = value
			    zValueType = pValueTypeOfVariant( value )
			  end if
			  
			  '// Keep the parent in sync
			  'dim p as MacPListBrowser = me.Parent
			  'if p <> nil then
			  'if p.Type = ValueType.IsArray then
			  'p.Child( zParentIndex.IntegerValue ) = zValue
			  'else
			  'p.Child( zParentIndex.StringValue ) = zValue
			  'end if
			  'end if
			  
			End Set
		#tag EndSetter
		VariantValue As Variant
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private zParent As WeakRef
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zParentIndex As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zValue As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private zValueType As ValueType
	#tag EndProperty


	#tag Enum, Name = ValueType, Type = Integer, Flags = &h0
		IsNil
		  IsDictionary
		  IsArray
		  IsString
		  IsDate
		  IsBoolean
		  IsData
		  IsNumber
		IsUnknown
	#tag EndEnum


End Class
#tag EndClass