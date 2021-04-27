#tag Class
Protected Class introStep
	#tag Method, Flags = &h21
		Private Sub addOuterContainer(parent as EmbeddedWindowControl, pos as introStepPosition)
		  pos.L = parent.Left + pos.L
		  pos.T = parent.Top + pos.T
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub addOuterContainer(parent as rectcontrol, pos as introStepPosition)
		  pos.L = parent.Left
		  pos.T = parent.Top
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub applyOptionToBackground(cntBG as introcnt)
		  cntBG.closeStepByClickOnBackground = Self.closeStepByClickOnBackground
		  
		  If useOwnColors Then
		    cntBG.BackgroundColor = Self.backgroundColorBackground
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub applyOptionToMessage(cntMes as introMessageMultiple)
		  cntMes.closeStepByClickOnDescription = Self.closeStepByClickOnDescription
		  cntMes.statusIndicatorVisible = Self.statusIndicatorVisible
		  cntMes.currIndex = Self.currIndex
		  cntMes.maxIndex = Self.maxIndex
		  
		  If useOwnColors Then
		    cntMes.RoundRectangle1.FillColor = Self.backgroundColorMessage
		    cntMes.RoundRectangle1.BorderColor = Self.borderColorMessage
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub applyOptionToMessage(cntMes as introMessageSingle)
		  cntMes.closeStepByClickOnDescription = Self.closeStepByClickOnDescription
		  
		  If useOwnColors Then
		    cntMes.RoundRectangle1.FillColor = Self.backgroundColorMessage
		    cntMes.RoundRectangle1.BorderColor = Self.borderColorMessage
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub backgroundClicked(sender as introcnt)
		  Self.remove
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub cancelCalled(sender as introMessageMultiple)
		  Self.remove
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(focusControls_() as RectControl, title_ as string, message_ as String)
		  // highlight has an array of controls
		  // find the boundries:
		  Var maxL, maxT As Integer = 1000000
		  Var maxR, maxB As Integer = 0
		  Self.focusControlArray = focusControls_
		  
		  For Each c As RectControl In Self.focusControlArray
		    If c.Left < maxL Then maxL = c.Left
		    If c.top < maxT Then maxt = c.top
		    
		    If (c.top + c.Height) > maxB Then maxB = (c.top + c.Height)
		    If (c.Left + c.Width) > maxR Then maxR = (c.Left + c.Width)
		  Next
		  
		  Var win As Window = focusControls_(0).Window
		  Self.myWindow = win
		  Self.ControlArrayMyWindow = win
		  
		  Var r As New RectControl
		  r.Left = maxL
		  r.Top = maxT
		  r.Width =  maxR - maxL
		  r.Height =  maxB - maxT
		  
		  
		  Self.focusControl = r
		  Self.title = title_
		  Self.message = message_
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(focusControl_ as RectControl, title_ as string, message_ as String)
		  Self.focusControl = focusControl_
		  Self.title = title_
		  self.message = message_
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(focusWindow_ as window, title_ as string, message_ as String)
		  Self.focusWindow = focusWindow_
		  Self.title = title_
		  Self.message = message_
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayBackgroundRectControl()
		  // find position
		  Var pos As New introStepPosition(Self.focusControl)
		  Self.focusControlPosition = pos
		  
		  Var parent As Variant
		  
		  parent = focusControl.Parent
		  
		  If myWindow = Nil Then
		    If parent = Nil Then
		      // control is directly in a window
		      If focusWindow IsA ContainerControl Then
		        Var focCC As ContainerControl = ContainerControl(focusWindow)
		        myWindow = focCC.Window
		      Else
		        myWindow = focusControl.Window
		      End If
		    Else
		      // control is in a subcontrol
		      
		      While Not myWindow IsA Window
		        If Not parent IsA Window Then 
		          
		          // calc position
		          Var parentRect As RectControl 
		          Var parentContainer As EmbeddedWindowControl
		          
		          If parent IsA EmbeddedWindowControl Then
		            parentContainer = EmbeddedWindowControl(parent)
		            Self.addOuterContainer(parentContainer, pos)
		          Else
		            parentRect = RectControl(parent)
		            Self.addOuterContainer(parentRect, pos)
		          End If
		          
		          // check if its the base window
		          If parent IsA EmbeddedWindowControl Then
		            parent = parentContainer.Window
		          Else
		            parent = parentRect.Parent
		          End If
		          
		        Else
		          myWindow = parent
		        End If
		        
		      Wend
		    End If
		  End If
		  
		  // embed containers
		  
		  Var cTop As New introCnt
		  Var cLeft As New introCnt
		  Var cBottom As New introCnt
		  Var cRight As New introCnt
		  
		  applyOptionToBackground(cTop)
		  applyOptionToBackground(cLeft)
		  applyOptionToBackground(cBottom)
		  applyOptionToBackground(cRight)
		  
		  cTop.EmbedWithin(myWindow, 0, 0, myWindow.Width, pos.T)
		  cbottom.EmbedWithin(myWindow, 0, pos.T + pos.H, myWindow.Width, myWindow.Height - pos.T - pos.H)
		  cLeft.EmbedWithin(myWindow, 0, pos.T, pos.L, pos.H)
		  cRight.EmbedWithin(myWindow, pos.L + pos.W, pos.T, myWindow.Width - pos.L - pos.W, pos.H)
		  
		  Self.cntBottom = cBottom
		  Self.cntLeft = cLeft
		  Self.cntTop = cTop
		  Self.cntRight = cRight
		  
		  AddHandler cTop.clicked, AddressOf backgroundClicked
		  AddHandler cLeft.clicked, AddressOf backgroundClicked
		  AddHandler cBottom.clicked, AddressOf backgroundClicked
		  AddHandler cRight.clicked, AddressOf backgroundClicked
		  
		  // display message
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayBackgroundWindowControl()
		  
		  If focusWindow IsA ContainerControl Then
		    // containercontrol
		    MessageBox("container")
		  Else
		    // window
		    Var cTop As New introCnt
		    cTop.EmbedWithin(focusWindow, 0, 0, focusWindow.Width, focusWindow.Width)
		    AddHandler cTop.clicked, AddressOf backgroundClicked
		    
		    Self.cntTop = cTop
		    
		    applyOptionToBackground(cTop)
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub displayIntroMessage()
		  If myWindow Is Nil And focusWindow <> Nil Then
		    // is a window or containercontrol
		    If focusWindow IsA ContainerControl Then
		      //MessageBox("container")
		      
		    Else
		      // window
		      Var L, T As Integer
		      L = (focusWindow.Width / 2) - (Self.introMessageContainer.Width / 2)
		      T = (focusWindow.Height / 2) - (Self.introMessageContainer.Height / 2)
		      
		      Self.introMessageContainer.EmbedWithin(focusWindow, L, T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		    End If
		    
		  Else
		    Var pos As introStepPosition = Self.focusControlPosition
		    Var gapToBottom As Integer = myWindow.Height - pos.T - pos.H + 5
		    
		    If gapToBottom > Self.introMessageContainer.Height Then
		      // embed below
		      Self.introMessageContainer.EmbedWithin(myWindow, pos.L, pos.T + pos.H + 5, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		    Else
		      
		      Var gapToTop As Integer =  pos.T - 5
		      If gapToTop > Self.introMessageContainer.Height Then
		        // embed above
		        Self.introMessageContainer.EmbedWithin(myWindow, pos.L, pos.T - Self.introMessageContainer.Height - 5, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		      Else
		        Var gap_right As Integer = myWindow.Width - pos.L - pos.W -5
		        If gap_right > Self.introMessageContainer.Width Then
		          // embed right
		          Self.introMessageContainer.EmbedWithin(myWindow, pos.L + pos.W + 5, pos.T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		          
		        Else
		          Var gap_left As Integer = pos.L - 5
		          If gap_left > Self.introMessageContainer.Width Then
		            // embed left
		            Self.introMessageContainer.EmbedWithin(myWindow, pos.L - 5 - Self.introMessageContainer.Width, pos.T, Self.introMessageContainer.Width, Self.introMessageContainer.Height)
		            
		          Else
		            // cannot embed
		            // Display a modal dialog
		            Var m As New MessageDialog
		            m.Message = Self.title + EndOfLine + EndOfLine + Self.message
		            
		            If Self.statusIndicatorVisible Then
		              m.Message = m.Message + EndOfLine + EndOfLine + "Step " + CStr(Self.currIndex + 1) + " of " + CStr(Self.maxIndex + 1)
		            End If
		            
		            If Not Self.isLastStep Then
		              m.IconType = MessageDialog.IconTypes.Note
		              m.ActionButton.Caption = "Next"
		            End If
		            If Not Self.isFirstStep Then
		              m.AlternateActionButton.Visible = True
		              m.AlternateActionButton.Caption = "Previous"
		            End If
		            
		            m.CancelButton.Visible = True
		            If Self.isLastStep Then
		              m.CancelButton.Caption = "Finish"
		            Else
		              m.CancelButton.Caption = "Cancel"
		            End If
		            
		            Var erg As MessageDialogButton = m.showmodal
		            Select Case erg
		            Case m.ActionButton
		              // next
		              RaiseEvent callNextStep
		            Case m.AlternateActionButton
		              // prev
		              RaiseEvent callPrevStep
		            Case m.CancelButton
		              RaiseEvent callCancel
		            End Select
		            
		            Self.remove
		          End If
		          
		        End If
		      End If
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub nextCalled(sender as introMessage)
		  RaiseEvent CallNextStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub prevCalled(sender as introMessage)
		  
		  RaiseEvent CallPrevStep
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub remove()
		  
		  Var shouldClose As Boolean = False
		  
		  
		  If Self.cntTop <> Nil Then
		    shouldClose = True
		    Self.cntTop.Close
		  End If
		  
		  If Self.cntBottom <> Nil Then
		    shouldClose = True
		    Self.cntBottom.Close
		  End If
		  
		  If Self.cntLeft <> Nil Then
		    shouldClose = True
		    Self.cntLeft.Close
		  End If
		  
		  If Self.cntRight <> Nil Then
		    shouldClose = True
		    Self.cntRight.Close
		  End If
		  
		  
		  If shouldClose Then
		    Self.introMessageContainer.Close
		  End If
		  
		  If Self.myWindow <> Nil Then
		    RemoveHandler myWindow.resizing, WeakAddressOf windowResized
		  End If
		  
		  
		  
		  Self.cntBottom = Nil
		  Self.cntTop = Nil
		  Self.cntLeft = Nil
		  Self.cntRight = Nil
		  
		  Self.introMessageContainer = Nil
		  
		  Self.myWindow = Nil
		  
		  RaiseEvent callCancel
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub resize()
		  
		  
		  // find position
		  Var pos As New introStepPosition(Self.focusControl)
		  Self.focusControlPosition = pos
		  
		  If self.focusControlArray.Ubound > -1 Then
		    Var maxL, maxT As Integer = 1000000
		    Var maxR, maxB As Integer = 0
		    
		    For Each c As RectControl In Self.focusControlArray
		      If c.Left < maxL Then maxL = c.Left
		      If c.top < maxT Then maxt = c.top
		      
		      If (c.top + c.Height) > maxB Then maxB = (c.top + c.Height)
		      If (c.Left + c.Width) > maxR Then maxR = (c.Left + c.Width)
		    Next
		    
		    pos.L = maxL
		    pos.T = maxT
		    pos.W =  maxR - maxL
		    pos.h =  maxB - maxT
		  End If
		  
		  Var parent As Variant
		  
		  parent = focusControl.Parent
		  
		  If myWindow = Nil Then
		    If parent = Nil Then
		      // control is directly in a window
		      If focusWindow IsA ContainerControl Then
		        Var focCC As ContainerControl = ContainerControl(focusWindow)
		        myWindow = focCC.Window
		      Else
		        myWindow = focusControl.Window
		      End If
		    Else
		      // control is in a subcontrol
		      
		      While Not myWindow IsA Window
		        If Not parent IsA Window Then 
		          
		          // calc position
		          Var parentRect As RectControl 
		          Var parentContainer As EmbeddedWindowControl
		          
		          If parent IsA EmbeddedWindowControl Then
		            parentContainer = EmbeddedWindowControl(parent)
		            Self.addOuterContainer(parentContainer, pos)
		          Else
		            parentRect = RectControl(parent)
		            Self.addOuterContainer(parentRect, pos)
		          End If
		          
		          // check if its the base window
		          If parent IsA EmbeddedWindowControl Then
		            parent = parentContainer.Window
		          Else
		            parent = parentRect.Parent
		          End If
		          
		        Else
		          myWindow = parent
		        End If
		        
		      Wend
		    End If
		  End If
		  
		  // resize containers
		  
		  Self.cntTop.Left = 0
		  Self.cntTop.Top = 0
		  Self.cntTop.Width = myWindow.Width
		  Self.cntTop.Height = pos.T
		  
		  
		  Self.cntbottom.Left = 0
		  Self.cntbottom.Top = pos.T + pos.H
		  Self.cntbottom.Width = myWindow.Width
		  Self.cntbottom.Height = myWindow.Height - pos.T - pos.H
		  
		  
		  Self.cntLeft.Left = 0
		  Self.cntLeft.Top = pos.T
		  Self.cntLeft.Width = pos.L
		  Self.cntLeft.Height = pos.H
		  
		  
		  Self.cntRight.Left = pos.L + pos.W
		  Self.cntRight.Top = pos.T
		  Self.cntRight.Width = myWindow.Width - pos.L - pos.W
		  Self.cntRight.Height = pos.H
		  
		  
		  // relocate message
		  
		  Var L, T, W, H As Integer
		  Self.introMessageContainer.Visible = True
		  
		  If myWindow Is Nil And focusWindow <> Nil Then
		    // is a window or containercontrol
		    If focusWindow IsA ContainerControl Then
		      //MessageBox("container")
		      
		    Else
		      // window
		      L = (focusWindow.Width / 2) - (Self.introMessageContainer.Width / 2)
		      T = (focusWindow.Height / 2) - (Self.introMessageContainer.Height / 2)
		      W = Self.introMessageContainer.Width
		      H = Self.introMessageContainer.Height
		    End If
		    
		  Else
		    //Var pos As introStepPosition = Self.focusControlPosition
		    Var gapToBottom As Integer = myWindow.Height - pos.T - pos.H + 5
		    
		    If gapToBottom > Self.introMessageContainer.Height Then
		      // embed below
		      L = pos.L
		      T = pos.T + pos.H + 5
		      W = Self.introMessageContainer.Width
		      H = Self.introMessageContainer.Height
		    Else
		      
		      Var gapToTop As Integer =  pos.T - 5
		      If gapToTop > Self.introMessageContainer.Height Then
		        // embed above
		        L = pos.L
		        T = pos.T - Self.introMessageContainer.Height - 5
		        W = Self.introMessageContainer.Width
		        H = Self.introMessageContainer.Height
		      Else
		        Var gap_right As Integer = myWindow.Width - pos.L - pos.W -5
		        If gap_right > Self.introMessageContainer.Width Then
		          // embed right
		          L = pos.L + pos.W + 5
		          T = pos.T
		          W = Self.introMessageContainer.Width
		          H = Self.introMessageContainer.Height
		          
		        Else
		          Var gap_left As Integer = pos.L - 5
		          If gap_left > Self.introMessageContainer.Width Then
		            // embed left
		            L = pos.L - 5 - Self.introMessageContainer.Width
		            T = pos.T
		            W = Self.introMessageContainer.Width
		            H = Self.introMessageContainer.Height
		            
		          Else
		            // usually display a messagedialog, but this leads to bad UX, have to find a better sollution
		            Self.introMessageContainer.Visible = False
		            
		          End If
		          
		        End If
		      End If
		    End If
		  End If
		  
		  Self.introMessageContainer.Left = L
		  Self.introMessageContainer.Top = T
		  Self.introMessageContainer.Width = W
		  Self.introMessageContainer.Height = H
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub show()
		  If ControlArrayMyWindow <> Nil Then myWindow = ControlArrayMyWindow
		  
		  If focusWindow <> Nil Then
		    If focusWindow IsA ContainerControl Then
		      Var r As New RectControl
		      r.Left = focusWindow.Left
		      r.Top = focusWindow.Top
		      r.Width = focusWindow.Width
		      r.Height = focusWindow.Height
		      
		      
		      Self.focusControl = r
		      
		      Self.displayBackgroundRectControl
		    Else
		      Self.displayBackgroundWindowControl
		    End If
		  Else
		    Self.displayBackgroundRectControl
		  End If
		  
		  // multiple step UI
		  
		  Var mes As New introMessageMultiple
		  mes.title = Self.title
		  mes.message = Self.message
		  
		  Self.introMessageContainer = mes
		  mes.btn_next.Enabled = Not(Self.isLastStep)
		  mes.btn_prev.Enabled = Not(Self.isFirstStep)
		  
		  self.applyOptionToMessage(mes)
		  
		  If Self.isLastStep Then 
		    mes.btn_cancel.Caption = "Finish"
		    mes.btn_cancel.Default = True
		  Else
		    mes.btn_cancel.Caption = "Cancel"
		    mes.btn_cancel.Default = False
		  End If
		  
		  AddHandler mes.callCancel, AddressOf cancelCalled
		  AddHandler mes.callprev, AddressOf prevCalled
		  AddHandler mes.callnext, AddressOf nextCalled
		  
		  
		  If Self.myWindow <> Nil Then
		    AddHandler myWindow.resizing, WeakAddressOf windowResized
		  End If
		  
		  Self.displayIntroMessage
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub showSingle()
		  
		  Self.singleMode = True
		  
		  If ControlArrayMyWindow <> Nil Then myWindow = ControlArrayMyWindow
		  
		  If focusWindow <> Nil Then
		    If focusWindow IsA ContainerControl Then
		      Var r As New RectControl
		      r.Left = focusWindow.Left
		      r.Top = focusWindow.Top
		      r.Width = focusWindow.Width
		      r.Height = focusWindow.Height
		      
		      Self.focusControl = r
		      
		      Self.displayBackgroundRectControl
		    Else
		      Self.displayBackgroundWindowControl
		    End If
		  Else
		    Self.displayBackgroundRectControl
		  End If
		  
		  // multiple step UI
		  
		  Var mes As New introMessageSingle
		  mes.title = Self.title
		  mes.message = Self.message
		  
		  Self.introMessageContainer = mes
		  
		  self.applyOptionToMessage(mes)
		  
		  If Self.myWindow <> Nil Then
		    AddHandler myWindow.resizing, WeakAddressOf windowResized
		  End If
		  
		  Self.displayIntroMessage
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub windowResized(windw as Window)
		  If ControlArrayMyWindow <> Nil Then myWindow = ControlArrayMyWindow
		  
		  Self.resize
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event callCancel()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event callNextStep()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event callPrevStep()
	#tag EndHook


	#tag Property, Flags = &h0
		backgroundColorBackground As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		backgroundColorMessage As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		borderColorMessage As Color
	#tag EndProperty

	#tag Property, Flags = &h0
		closeStepByClickOnBackground As Boolean = true
	#tag EndProperty

	#tag Property, Flags = &h0
		closeStepByClickOnDescription As Boolean = true
	#tag EndProperty

	#tag Property, Flags = &h0
		cntBottom As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntLeft As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntRight As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		cntTop As introCnt
	#tag EndProperty

	#tag Property, Flags = &h0
		ControlArrayMyWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h0
		currIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		focusControl As RectControl
	#tag EndProperty

	#tag Property, Flags = &h0
		focusControlArray() As rectControl
	#tag EndProperty

	#tag Property, Flags = &h21
		Private focusControlPosition As introStepPosition
	#tag EndProperty

	#tag Property, Flags = &h0
		focusWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h0
		introMessageContainer As introMessage
	#tag EndProperty

	#tag Property, Flags = &h0
		isFirstStep As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		isLastStep As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		maxIndex As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		message As string
	#tag EndProperty

	#tag Property, Flags = &h21
		Private myWindow As Window
	#tag EndProperty

	#tag Property, Flags = &h0
		singleMode As boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		statusIndicatorVisible As Boolean = true
	#tag EndProperty

	#tag Property, Flags = &h0
		title As string
	#tag EndProperty

	#tag Property, Flags = &h0
		useOwnColors As Boolean = false
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="focusWindow"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Window"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="isFirstStep"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="isLastStep"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="singleMode"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ControlArrayMyWindow"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Window"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="closeStepByClickOnBackground"
			Visible=false
			Group="Behavior"
			InitialValue="true"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="closeStepByClickOnDescription"
			Visible=false
			Group="Behavior"
			InitialValue="true"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="useOwnColors"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="backgroundColorBackground"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="backgroundColorMessage"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="borderColorMessage"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="statusIndicatorVisible"
			Visible=false
			Group="Behavior"
			InitialValue="true"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
