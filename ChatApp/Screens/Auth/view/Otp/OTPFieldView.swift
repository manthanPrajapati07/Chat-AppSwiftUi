//
//  OTPFieldView.swift
//  OTP Field View
//
//  Created by Jayant on 06/10/23.
//


import SwiftUI
import Combine


// A SwiftUI view for entering OTP (One-Time Password).
struct OTPFieldView: View {
    
    @FocusState private var pinFocusState: FocusPin?
    @Binding private var otp: String
    @State private var pins: [String] = ["-","-","-","-","-","-"]
    
    var numberOfFields: Int
    
    enum FocusPin: Hashable {
        case pin(Int)
    }
    
    init(numberOfFields: Int, otp: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otp = otp
        self._pins = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("-" , text: $pins[index])
                    .modifier(OtpModifier(pin: $pins[index]))
                    .foregroundColor(.black)
                    .onChange(of: pins[index]) { newVal in
                        if newVal.count == 1 {
                            if index < numberOfFields - 1 {
                                pinFocusState = FocusPin.pin(index + 1)
                            }
                        }
                        else if newVal.count == numberOfFields, let intValue = Int(newVal) {
                           
                            otp = newVal
                            updatePinsFromOTP()
                            pinFocusState = FocusPin.pin(numberOfFields - 1)
                        }
                        else if newVal.isEmpty {
                            if index > 0 {
                                pinFocusState = FocusPin.pin(index - 1)
                            }
                        }
                        updateOTPString()
                    }
                    .focused($pinFocusState, equals: FocusPin.pin(index))
                    .onTapGesture {
                
                        pinFocusState = FocusPin.pin(index)
                    }
            }
        }
        .onAppear {
        
            updatePinsFromOTP()
        }
    }
    
    private func updatePinsFromOTP() {
        let otpArray = Array(otp.prefix(numberOfFields))
        for (index, char) in otpArray.enumerated() {
            pins[index] = String(char)
        }
    }
    
    private func updateOTPString() {
        otp = pins.joined()
    }
}

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    var textLimit = 1
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 40, height: 48)
            .font(.system(size: 20, weight: .medium))
//            .background(
//                RoundedRectangle(cornerRadius: 2)
//                    .stroke(Color.gray, lineWidth: 1)
//            )
    }
}

struct OTPFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text("VERIFICATION CODE")
                .foregroundColor(Color.gray)
                .font(.system(size: 12))
            OTPFieldView(numberOfFields: 6, otp: .constant("543217"))
                .previewLayout(.sizeThatFits)
        }
    }
}



