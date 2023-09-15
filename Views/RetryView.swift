//
//  RetryView.swift
//  News App
//
//  Created by Khushali Vagadia on 15/09/23.
//

import SwiftUI

struct RetryView: View {
    
    let text: String
    let retryAction: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            
            // Display error text with callout font and center alignment
            Text(text)
                .font(.callout)
                .multilineTextAlignment(.center)
            
            // Button to trigger retryAction
            Button(action: retryAction) {
                Text("Try again")
            }
        }
    }
}

struct RetryView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Preview of RetryView with sample error text and action
        RetryView(text: "An error occured") {
            
        }
    }
}
