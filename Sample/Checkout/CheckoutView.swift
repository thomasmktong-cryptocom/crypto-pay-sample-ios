//
//  ContentView.swift
//  Sample
//
//  Created by Thomas Tong on 5/1/2021.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var settings = UserSettings()
    
    @State var paymentId = ""
    @State var paymentUrl: URL?
    @State var successResultFromWebView = false
    @State var alertMessage = ""
    
    @State var showAlert = false
    @State var showSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: SettingsView(userSettings: settings),
                        label: {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.blue)
                                .padding(.trailing, 20)
                                .padding(.top, 20)
                        }).padding(.bottom, 20)
                }
                
                HStack {
                    Image("Hoodie")
                        .resizable()
                        .frame(minWidth: 0, idealWidth: 100, maxWidth: 100, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .center)
                        .padding(.leading, 20)
                    
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("Crypto.com Hoodie")
                        
                        Text("Size: M")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 10))
                        
                        Text("Quantity: 1")
                            .foregroundColor(Color.gray)
                            .font(.system(size: 10))
                        
                        Text("$50.00")
                            .foregroundColor(Color.gray)
                        
                    }).padding(.trailing, 20).frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .leading)
                }
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading, spacing: 5, content: {
                        
                        Text("Subtotal")
                        Text("Shipping")
                        Text("Total*")
                        Text("*Custom duties or taxes not included")
                            .font(.system(size: 10)).fixedSize()
                        
                    }).padding(.leading, 20).frame(minWidth: 120, idealWidth: 120, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .topLeading)
                    
                    VStack(alignment: .trailing, spacing: 5, content: {
                        Text("$50.00")
                        Text("Free")
                        Text("USD $50.00")
                    }).padding(.trailing, 20).frame(minWidth: 120, idealWidth: 120, maxWidth: .infinity, minHeight: 0, idealHeight: 100, maxHeight: 100, alignment: .topTrailing)
                }
                
                Button(action: {
                    
                    self.successResultFromWebView = false
                    
                    /*
                     * Create the Payment using Crypto.com Pay API.
                     * Refer to https://pay-docs.crypto.com/ for API documentation.
                     * In real world App implementation, the App should be sending a checkout to merchant server,
                     * and then merchant server creates the Payment (and only server holds the Crypto.com API secret key).
                     */
                    let api = PaymentApi(payServerHost: settings.payServerHost, secretKey: settings.secretKey)
                    let paymentJson = api.createPayment()
                    
                    let error = paymentJson["error"] as? [String: Any]
                    if error == nil {
                        self.paymentId = paymentJson["id"] as! String
                        self.paymentUrl = URL(string: paymentJson["payment_url"] as! String)
                        
                        /*
                         * When the Payment is created, open a WebView to display the `payment_url`.
                         * Wait for the redirection to happen.
                         */
                        self.showSheet.toggle()
                        
                    } else {
                        alertMessage = error!["code"] as! String
                        showAlert = true
                    }
                    
                }) {
                    Text("PAY")
                        .frame(width: 280, height: 50, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                }.sheet(isPresented: $showSheet, onDismiss: {
                    
                    /*
                     * SwiftUIWebView detects the redirects and then close the sheet, returning to this one.
                     * The App should then inform merchant server to completes the order.
                     * In merchant server, it should get the Payment from Crypto.com Pay API again,
                     * and confirm the `status` is `succeeded`.
                     * If so, server can finish the order and the App can show an order completion message.
                     */
                    if successResultFromWebView {
                        let api = PaymentApi(payServerHost: settings.payServerHost, secretKey: settings.secretKey)
                        let paymentJson = api.getPayment(paymentId: paymentId)
                        
                        let error = paymentJson["error"] as? [String: Any]
                        if error == nil {
                            let status = paymentJson["status"] as! String
                            alertMessage = "Payment " + paymentId + " is " + status
                            showAlert = true
                        } else {
                            alertMessage = error!["code"] as! String
                            showAlert = true
                        }
                    }
                }) {
                    SwiftUIWebView(url: $paymentUrl, showSheet: $showSheet, successResult: $successResultFromWebView)
                }.padding(.bottom, 20)
                
            }.alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage))
            }
            .navigationBarTitle("Back")
            .navigationBarHidden(true)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
