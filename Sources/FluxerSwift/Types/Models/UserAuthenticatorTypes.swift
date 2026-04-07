public enum UserAuthenticatorTypes: Int, Codable {
    case totp = 0
    case sms = 1
    case webauthn = 2
}
