//
//  ContentView.swift
//  Sample
//
//  Created by Thomas Tong on 5/1/2021.
//

import SwiftUI

struct CheckoutView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: SettingsView(),
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
                
                NavigationLink(
                    destination: SwiftUIWebView(url: URL(string: "https://apple.com/")),
                    label: {
                        Text("PAY")
                            .frame(width: 280, height: 50, alignment: .center)
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                    }).padding(.bottom, 20)
            }
            .navigationBarTitle("Back")
            .navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
    }
}
