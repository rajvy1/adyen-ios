//
// Copyright (c) 2022 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

@_spi(AdyenInternal) import Adyen
import Adyen3DS2
import Foundation
#if canImport(AdyenAuthentication)
    import AdyenAuthentication
#endif

extension ThreeDS2CompactActionHandler {
    
    /// Initializes the 3D Secure 2 action handler.
    internal convenience init(context: AdyenContext,
                              appearanceConfiguration: ADYAppearanceConfiguration,
                              delegatedAuthenticationConfiguration: ThreeDS2Component.Configuration.DelegatedAuthentication?) {
        
        let fingerprintSubmitter = ThreeDS2FingerprintSubmitter(apiContext: context.apiContext)
        self.init(
            context: context,
            fingerprintSubmitter: fingerprintSubmitter,
            appearanceConfiguration: appearanceConfiguration,
            coreActionHandler: Self.createDefaultThreeDS2CoreActionHandler(
                context: context,
                appearanceConfiguration: appearanceConfiguration,
                delegatedAuthenticationConfiguration: delegatedAuthenticationConfiguration
            ),
            delegatedAuthenticationConfiguration: delegatedAuthenticationConfiguration
        )
    }
    
    internal static func createDefaultThreeDS2CoreActionHandler(
        context: AdyenContext,
        appearanceConfiguration: ADYAppearanceConfiguration,
        delegatedAuthenticationConfiguration: ThreeDS2Component.Configuration.DelegatedAuthentication?
    ) -> AnyThreeDS2CoreActionHandler {
        #if canImport(AdyenAuthentication)
            if #available(iOS 14.0, *), let delegatedAuthenticationConfiguration = delegatedAuthenticationConfiguration {
                return ThreeDS2PlusDACoreActionHandler(context: context,
                                                       appearanceConfiguration: appearanceConfiguration,
                                                       delegatedAuthenticationConfiguration: delegatedAuthenticationConfiguration)
            } else {
                return ThreeDS2CoreActionHandler(context: context,
                                                 appearanceConfiguration: appearanceConfiguration)
            }
        #else
            return ThreeDS2CoreActionHandler(context: context,
                                             appearanceConfiguration: appearanceConfiguration)
        #endif
    }
}
