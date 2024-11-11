USE rd2;

create table if not exists MemberDevice (
    ID bigint auto_increment primary key,
    MemberID char(36) collate utf8mb4_bin default '' not null,
    DeviceToken varchar(512) null,
    DeviceCode varchar(100) null,
    DeviceOS int null,
    DeviceOSVersion varchar(100) null,
    AppVersion varchar(100) null,
    index ind_deviceos_appversion (DeviceOS, AppVersion)
) collate = utf8mb4_unicode_ci;

-- auto-generated definition
create table if not exists JKOSMessage (
    ID bigint auto_increment primary key,
    Target int not null,
    MessageTitle varchar(20) charset utf8 null,
    MessageContent varchar(1000) charset utf8 null,
    CreateTime datetime not null,
    UpdateTime datetime null,
    FinishTime datetime null,
    PublishType int not null,
    PublishStatus int not null,
    ReservationTime datetime null,
    TagType int not null,
    BehaviorType int not null,
    WebUrl longtext null,
    OrderID char(36) collate latin1_bin null,
    ReservationID bigint null,
    CommentID char(36) collate latin1_bin null,
    FeedBackID char(36) collate latin1_bin null,
    WaitingID char(36) collate latin1_bin null,
    MemberID char(36) collate latin1_bin null,
    ConsumeID bigint null,
    boxed_message_template_id varchar(64) null,
    index IX_MemberID (MemberID),
    index IX_Target_TagType_MemberID (Target, TagType, MemberID)
);

-- auto-generated definition
create table if not exists MemberUnreadMessage (
    Collect int not null,
    JKOSMessage int not null,
    PurchaseRecord int not null,
    RefundRecord int not null,
    WaitComment int not null,
    Reservation int not null,
    WaitingPosition int not null,
    ProposalFeedback int not null,
    PricelessCoupon int not null,
    UsedConpon int not null,
    MemberID char(36) collate latin1_bin default '' not null primary key,
    TakeMeal int not null,
    ValuableCoupon int not null,
    Delivery int not null,
    Friend int not null,
    JKOCoupon int not null,
    index IX_MemberID (MemberID)
);