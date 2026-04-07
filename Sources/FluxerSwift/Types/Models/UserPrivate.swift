public struct UserPrivate: Codable {
    public let accent_color: Int32?
    public let acls: [String]
    public let authenticator_types: [UserAuthenticatorTypes]?
    public let avatar: String?
    public let avatar_color: Int32?
    public let banner: String?
    public let banner_color: Int32?
    public let bio: String?
    public var bot: Bool = false
    public let discriminator: String
    public let email: String?
    public let email_bounced: Bool?
    public let flags: PublicUserFlags
    public let global_name: String?
    public let has_dismissed_premium_onboarding: Bool
    public let has_ever_purchased: Bool
    public let has_unread_gift_inventory: Bool
    public let id: Snowflake
    public let is_staff: Bool
    public let mfa_enabled: Bool
    public let nsfw_allowed: Bool
    public let password_last_changed_at: String?
    public let pending_bulk_message_deletion: UserPrivatePendingBulkMessageDeletion?
    public let phone: String?
    public let premium_badge_hidden: Bool
    public let premium_badge_masked: Bool
    public let premium_badge_sequence_hidden: Bool
    public let premium_badge_timestamp_hidden: Bool
    public let premium_billing_cycle: String?
    public let premium_enabled_override: Bool
    public let premium_lifetime_sequence: Int32?
    public let premium_purchase_disabled: Bool
    public let premium_since: String?
    public let premium_type: UserPremiumTypes?
    public let premium_until: String?
    public let premium_will_cancel: Bool
    public let pronouns: String?
    public let required_actions: String?
    public let system: Bool?
    public var tag: String {
        "\(self.username)#\(self.discriminator)"
    }
    public let traits: [String]
    public let unread_gift_inventory_count: Int
    public let used_mobile_client: Bool
    public let username: String
    public let verified: Bool
}
