create table if not exists charity_admin_user (
    id bigint auto_increment primary key,
    user_id varchar(50) not null comment '由捐款系統產生，用來提供外部系統識別用戶身分',
    charity_group_id bigint not null comment 'FK: charity_group.id',
    username varchar(100) null comment '帳號。若由AM後台轉跳或是由OAuth登入，此欄位為空',
    password varchar(100) null comment '密碼。若由AM後台轉跳或是由OAuth登入，此欄位為空',
    email varchar(320) null comment '若由AM後台轉跳或是由OAuth登入，此欄位為空',
    role varchar(10) not null comment 'MANAGER, STAFF',
    is_active bit not null,
    token varchar(50) null comment '外部後台API Authorization token',
    token_expired_time timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '外部後台API Authorization token過期時間',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint token_idx unique (token),
    constraint user_id_idx unique (user_id),
    constraint username_idx unique (username)
) charset = utf8mb4;

create table if not exists charity_group (
    id bigint auto_increment primary key,
    group_name varchar(50) not null comment '團體名稱',
    registration_number varchar(50) not null comment '核准字號',
    tax_id_number varchar(50) not null comment '統一編號',
    phone varchar(20) not null comment '聯絡電話',
    email varchar(320) not null comment '聯絡信箱',
    website varchar(1000) not null comment '官方網站',
    introduction varchar(50) null comment '簡介',
    content varchar(1000) null comment '介紹',
    logo_url varchar(1000) not null comment 'Logo URL',
    status varchar(20) not null comment 'ACTIVE:上架中, HIDDEN:已隱藏',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint group_name_idx unique (group_name),
    constraint registration_number_idx unique (registration_number),
    constraint tax_id_number_idx unique (tax_id_number),
    index status_idx (status)
) charset = utf8mb4;

create table if not exists charity_group_mail_config (
    id bigint auto_increment primary key,
    charity_group_id bigint not null,
    report_day int not null comment '報表每月寄送日',
    receiver varchar(320) not null comment '收件人，逗號分隔',
    carbon_copy varchar(320) null comment '副本，逗號分隔',
    enabled bit default b'1' not null comment '是否發送報表',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    INDEX charity_group_id_idx (charity_group_id)
) charset = utf8mb4;

create table if not exists charity_group_store_id (
    id bigint auto_increment primary key,
    charity_group_id bigint not null,
    store_id varchar(36) not null,
    store_name varchar(10) null comment '店鋪名稱。僅供AM人員識別之用，無任何邏輯',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint store_id_idx unique (store_id),
    INDEX charity_group_id_idx (charity_group_id)
) charset = utf8mb4;

create table if not exists charity_product (
    id bigint auto_increment primary key,
    charity_group_id bigint not null comment 'FK: charity_group.id',
    store_id varchar(36) null,
    product_number varchar(50) not null comment '商品編號',
    product_name varchar(50) not null comment '商品名稱',
    content varchar(1000) not null comment '商品內容',
    registration_number varchar(50) not null comment '勸募立案核准字號',
    shipping_fee_rule_id bigint not null comment 'FK: shipping_fee_rule.id',
    start_time timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '開始販售時間',
    end_time timestamp(3) null comment '結束販售時間。null = 永久',
    is_available bit not null comment '是否上架中',
    marketing_label varchar(10) null comment '行銷推廣文字',
    marketing_icon_url varchar(500) null comment '行銷推廣文字 ICON',
    old_db_id bigint null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint old_db_id_idx unique (old_db_id),
    constraint product_number_idx unique (product_number),
    INDEX charity_group_id_idx (charity_group_id),
    INDEX product_name_idx (product_name),
    INDEX registration_number_idx (registration_number),
    INDEX store_id_idx (store_id)
) charset = utf8mb4;

create table if not exists charity_product_image (
    id bigint auto_increment primary key,
    charity_product_id bigint not null comment 'FK: charity_product.id',
    charity_product_variant_id bigint null comment 'FK: charity_product_variant.id 若有值則代表此圖片特別屬於指定的品項',
    image_url varchar(500) not null comment '商品圖片URL',
    is_cover_image bit not null comment '是否為封面照片',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    INDEX charity_product_id_idx (charity_product_id),
    INDEX charity_product_variant_id_idx (charity_product_variant_id)
) charset = utf8mb4;

create table if not exists charity_product_variant (
    id bigint auto_increment primary key,
    charity_product_id bigint not null comment 'FK: charity_product.id',
    product_variant_name varchar(10) not null comment '品項名稱',
    price int not null comment '價格',
    stock int not null comment '庫存數量',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index product_variant_name_idx (product_variant_name)
) charset = utf8mb4;

create table if not exists charity_project (
    id bigint auto_increment primary key,
    charity_group_id bigint not null,
    store_id varchar(36) null,
    project_type varchar(50) null comment '專案類型 PROJECT:專案捐款, GROUP:團體捐款',
    project_name varchar(100) not null comment '專案名稱',
    project_registration_number varchar(50) not null comment '勸募立案核准字號',
    start_time timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '專案開始時間',
    end_time timestamp(3) null comment '專案結束時間',
    single_donation bit not null comment '單次捐款 0:關閉, 1:開放',
    regular_donation bit not null comment '定期捐款 0:關閉, 1:開放',
    is_declare_tax_online bit not null comment '支援電子申報 0:不支援, 1:支援',
    min_donation_amount int null comment '最低捐款金額',
    marketing_label varchar(10) null comment '行銷推廣文字',
    marketing_icon_url varchar(1000) null comment '行銷推廣文字 ICON',
    content varchar(1000) null comment '專案內容',
    status varchar(20) not null comment 'ACTIVE:上架中, HIDDEN:已隱藏, INACTIVE:已下架',
    old_db_id bigint null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint old_db_id_idx unique (old_db_id),
    index charity_group_id_idx (charity_group_id),
    index end_time_idx (end_time),
    index start_time_idx (start_time)
) charset = utf8mb4;

create table if not exists charity_project_image (
    id bigint auto_increment primary key,
    charity_project_id bigint not null,
    is_cover_image bit not null comment '是否為封面照片',
    image_url varchar(1000) not null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_project_id_idx (charity_project_id)
) charset = utf8mb4;

create table if not exists charity_sale_order (
    id bigint auto_increment primary key,
    charity_group_id bigint not null comment 'FK: charity_group.id',
    store_id varchar(36) not null,
    jkos_id varchar(40) not null comment '付款人 JkosId。和捐款人不一定相同',
    donor_name varchar(20) null comment '捐款人姓名',
    donor_identity varchar(20) null comment '捐款人身分證字號',
    donor_phone varchar(20) null comment '捐款人聯絡電話',
    donor_email varchar(320) null comment '捐款人聯絡信箱',
    donor_address_city varchar(5) null comment '捐款人聯絡地址(縣市)',
    donor_address_district varchar(5) null comment '捐款人聯絡地址(區)',
    donor_address_zip_code varchar(6) null comment '捐款人聯絡地址(郵遞區號)',
    donor_address_detail varchar(200) null comment '捐款人聯絡地址(細節)',
    is_anonymous bit not null comment '是否匿名捐款',
    receiver_name varchar(20) null comment '收件人姓名',
    receiver_phone varchar(20) null comment '收件人聯絡電話',
    receiver_email varchar(320) null comment '收件人聯絡信箱',
    receiver_address_city varchar(5) null comment '收件人聯絡地址(縣市)',
    receiver_address_district varchar(5) null comment '收件人聯絡地址(區)',
    receiver_address_zip_code varchar(6) null comment '收件人聯絡地址(郵遞區號)',
    receiver_address_detail varchar(200) null comment '收件人聯絡地址(細節)',
    receipt_type varchar(10) not null comment '收據類型。SINGLE:單次紙本',
    item_total_amount int not null comment '訂單購買品項總金額',
    shipping_fee int not null comment '運費',
    payment_amount int not null comment '訂單總金額。payment_amount = item_total_amount + shipping_fee',
    remark varchar(50) null comment '備註。買家給公益團體的留言',
    transaction_number varchar(50) not null comment '捐款交易編號。由捐款自訂，對應onlinepay的platform_order_id',
    transaction_status varchar(50) not null comment '付款狀態: SUCCESS,UNPAID,FAILED',
    transaction_expired_time timestamp(3) null comment '付款連結失效時間',
    transaction_time timestamp(3) null comment '交易時間',
    jko_trade_no varchar(30) null comment 'J單號。ex: J000384112110270000E。對應授扣tradeNo',
    shipping_status varchar(10) not null comment '出貨狀態: PENDING, PROCESSING, SHIPPED',
    shipping_remark varchar(200) null comment '出貨備註。公益團體留給捐款人的出貨留言',
    old_db_id bigint null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint jko_trade_no_idx unique (jko_trade_no),
    constraint old_db_id_idx unique (old_db_id),
    constraint transaction_number_idx unique (transaction_number),
    index charity_group_id_idx (charity_group_id),
    index donor_name_idx (donor_name),
    index jkos_id_idx (jkos_id),
    index shipping_status_idx (shipping_status),
    index transaction_status_idx (transaction_status)
) charset = utf8mb4;

create table if not exists charity_sale_order_item (
    id bigint auto_increment primary key,
    charity_sale_order_id bigint not null comment 'FK: charity_sale_order.id',
    charity_product_id bigint not null comment 'FK: charity_product.id',
    charity_product_variant_id bigint not null comment 'FK: charity_product_variant.id',
    product_number varchar(50) not null comment '商品編號',
    product_name varchar(50) not null comment '商品名稱',
    registration_number varchar(50) not null comment '勸募立案核准字號',
    product_variant_name varchar(10) not null comment '品項名稱',
    quantity int not null comment '數量',
    price int not null comment '單價',
    display_at_order_list bit not null comment '是否顯示在列表頁當作訂單的代表。一個訂單中只能有一個購買細項拿來顯示',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_product_id_idx (charity_product_id),
    index charity_product_variant_id_idx (charity_product_variant_id),
    index charity_sale_order_id_idx (charity_sale_order_id)
) charset = utf8mb4;

create table if not exists charity_sale_order_item_image (
    id bigint auto_increment primary key,
    charity_sale_order_id bigint not null comment 'FK: charity_sale_order.id',
    charity_product_id bigint not null comment 'FK: charity_product.id',
    charity_product_variant_id bigint null comment 'FK: charity_product_variant.id 若有值則代表此圖片特別屬於指定的品項',
    image_url varchar(500) not null comment '商品圖片URL',
    is_cover_image bit not null comment '是否為封面照片',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_product_id_idx (charity_product_id),
    index charity_product_variant_id_idx (charity_product_variant_id),
    index charity_sale_order_id_idx (charity_sale_order_id)
) charset = utf8mb4;

create table if not exists homepage_config (
    id bigint auto_increment primary key,
    config_key varchar(100) not null,
    config_value varchar(1000) not null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint config_key_idx unique (config_key)
) charset = utf8mb4;

create table if not exists item_id_mapping (
    id bigint auto_increment primary key,
    item_id bigint not null comment '舊系統 donation_item.id',
    representative_item_id bigint not null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint item_id unique (
        item_id,
        representative_item_id
    )
) charset = utf8mb4;

create table if not exists jko_store (
    id bigint auto_increment primary key,
    charity_group_id bigint not null,
    store_id varchar(36) not null,
    transaction_type varchar(30) not null comment '捐款類型: SINGLE_DONATION, REGULAR_DONATION, CHARITY_SALE',
    is_custom bit default b'0' not null comment '是否屬於自訂而非預設',
    charity_product_id bigint null comment '僅自訂時才可能有值',
    charity_project_id bigint null comment '僅自訂時才可能有值',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_group_id_idx (charity_group_id),
    index store_id_idx (store_id)
) charset = utf8mb4;

create table if not exists regular_donation_debit_history (
    id bigint auto_increment primary key,
    regular_donation_order_id bigint not null,
    expected_debit_date timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '預計扣款日期',
    jko_trade_no varchar(30) null comment 'J單號。ex: J000384112110270000E。對應授扣tradeNo',
    transaction_number varchar(100) not null comment '捐款交易編號。由捐款自訂，對應授扣platform_order_id',
    transaction_time timestamp(3) null comment '交易時間',
    receipt_type varchar(50) not null comment '收據開立方式 ELECTRONIC:電子申報,YEARLY:年度紙本,SINGLE:單次紙本,NONE:不需收據',
    donor_name varchar(50) null comment '捐款人姓名',
    donor_identity varchar(50) null comment '身分證字號',
    donor_phone varchar(50) null comment '聯絡電話',
    donor_email varchar(320) null comment '聯絡信箱',
    donor_address_city varchar(5) null comment '聯絡地址(縣市)',
    donor_address_district varchar(5) null comment '聯絡地址(區)',
    donor_address_zip_code varchar(6) null comment '聯絡地址(郵遞區號)',
    donor_address_detail varchar(200) null comment '聯絡地址(細節)',
    is_anonymous bit not null comment '是否匿名捐款',
    status varchar(50) not null comment '交易狀態: INIT,PROCESSING,SUCCESS,FAILED',
    failed_reason varchar(1000) null comment '扣款失敗原因',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint transaction_number_idx unique (transaction_number),
    index status_idx (status)
) charset = utf8mb4;

create table if not exists regular_donation_order (
    id bigint auto_increment primary key,
    charity_project_id bigint not null,
    store_id varchar(36) not null,
    regular_donation_number varchar(100) not null comment '定捐設定編號。由捐款自訂，對應授扣platform_authpay_id',
    jkos_id varchar(50) not null comment '付款人 JkosId',
    regular_donation_cycle_type varchar(30) default 'DAY_OF_MONTH' not null comment '扣款週期類型。DAY_OF_MONTH、NTH_DAY_OF_WEEK_OF_MONTH',
    monthly_debit_day tinyint null comment '每月扣款日',
    monthly_debit_week tinyint null comment '每月扣款週',
    weekly_debit_day tinyint null comment '每週扣款日',
    next_debit_date timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3) comment '下次扣款日期',
    amount int not null comment '扣款金額',
    receipt_type varchar(50) not null comment '收據開立方式 ELECTRONIC:電子申報,YEARLY:年度紙本,SINGLE:單次紙本,NONE:不需收據',
    donor_name varchar(50) null comment '捐款人姓名',
    donor_identity varchar(50) null comment '身分證字號',
    donor_phone varchar(50) null comment '聯絡電話',
    donor_email varchar(320) null comment '聯絡信箱',
    donor_address_city varchar(5) null comment '聯絡地址(縣市)',
    donor_address_district varchar(5) null comment '聯絡地址(區)',
    donor_address_zip_code varchar(6) null comment '聯絡地址(郵遞區號)',
    donor_address_detail varchar(200) null comment '聯絡地址(細節)',
    is_anonymous bit not null comment '是否匿名捐款',
    jko_auth_no varchar(50) null comment '街口端授權編號',
    authpay_status varchar(50) not null comment '授扣授權狀態: GRANTED,PROCESSING,FAILED,CANCELING,CANCELED',
    authpay_expired_time timestamp(3) null comment '授權連結失效時間',
    cancel_time timestamp(3) null comment '終止授權時間',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint regular_donation_number_idx unique (regular_donation_number)
) charset = utf8mb4;

create table if not exists shipping_fee_rule (
    id bigint auto_increment primary key,
    charity_group_id bigint not null comment 'FK: charity_group.id',
    name varchar(100) null,
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_group_id_idx (charity_group_id)
) charset = utf8mb4;

create table if not exists shipping_rate (
    id bigint auto_increment primary key,
    charity_group_id bigint not null comment 'FK: charity_group.id',
    shipping_fee_rule_id bigint not null comment 'FK: shipping_fee_rule.id',
    shipping_fee int not null comment '運費',
    lower_bound int not null comment 'lower_bound <= 商品總金額',
    upper_bound int null comment '商品總金額 < upper_bound。null = 無上限',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    index charity_group_id_idx (charity_group_id),
    index shipping_fee_rule_id_idx (shipping_fee_rule_id)
) charset = utf8mb4;

create table if not exists single_donation_order (
    id bigint auto_increment primary key,
    charity_project_id bigint not null,
    store_id varchar(36) not null,
    jkos_id varchar(50) not null comment '付款人 JkosId',
    amount int not null comment '扣款金額',
    receipt_type varchar(50) not null comment '收據開立方式 ELECTRONIC:電子申報,YEARLY:年度紙本,SINGLE:單次紙本,NONE:不需收據',
    donor_name varchar(50) null comment '捐款人姓名',
    donor_identity varchar(50) null comment '身分證字號',
    donor_phone varchar(50) null comment '聯絡電話',
    donor_email varchar(320) null comment '聯絡信箱',
    donor_address_city varchar(5) null comment '聯絡地址(縣市)',
    donor_address_district varchar(5) null comment '聯絡地址(區)',
    donor_address_zip_code varchar(6) null comment '聯絡地址(郵遞區號)',
    donor_address_detail varchar(200) null comment '聯絡地址(細節)',
    is_anonymous bit not null comment '是否匿名捐款',
    transaction_number varchar(100) not null comment '捐款交易編號。由捐款自訂，對應onlinepay的platform_order_id',
    transaction_status varchar(50) not null comment '付款狀態: SUCCESS,UNPAID,FAILED',
    transaction_expired_time timestamp(3) null comment '付款連結失效時間',
    transaction_time timestamp(3) null comment '交易時間',
    jko_trade_no varchar(30) null comment 'J單號。ex: J000384112110270000E。對應授扣tradeNo',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint transaction_number_idx unique (transaction_number),
    index charity_project_id_idx (charity_project_id),
    index jko_trade_no_idx (jko_trade_no),
    index jkos_id_idx (jkos_id),
    index transaction_status_idx (transaction_status)
) charset = utf8mb4;

create table if not exists tag_config (
    id bigint auto_increment primary key,
    type varchar(50) not null comment '標籤類型。CATEGORY:分類',
    tag_name varchar(50) not null comment '標籤名稱',
    tag_image_url varchar(1000) not null comment 'ICON 圖片',
    seq int not null comment '排序。數字小到大排',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null
) charset = utf8mb4;

create table if not exists tag_mapping (
    id bigint auto_increment primary key,
    tag_config_id bigint not null comment 'FK: tag_config.id',
    charity_group_id bigint not null comment 'FK: charity_group.id',
    charity_project_id bigint null comment 'FK: charity_project.id',
    charity_product_id bigint null comment 'FK: charity_product.id',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint tag_config_id_charity_product_id_idx unique (
        tag_config_id,
        charity_product_id
    ),
    constraint tag_config_id_charity_project_id_idx unique (
        tag_config_id,
        charity_project_id
    ),
    index charity_group_id_idx (charity_group_id)
) charset = utf8mb4;

create table if not exists transaction_history (
    id bigint auto_increment primary key,
    transaction_type varchar(50) not null comment '捐款類型 SINGLE_DONATION:單次捐款,REGULAR_DONATION:定期捐款,CHARITY_SALE:義賣商品',
    transaction_number varchar(100) not null comment '捐款交易編號',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null,
    constraint transaction_number_idx unique (transaction_number)
) charset = utf8mb4;

create table if not exists zip_code (
    id bigint auto_increment primary key,
    city varchar(5) not null comment '縣市',
    district varchar(5) not null comment '區',
    zip_code varchar(3) not null comment '郵遞區號',
    create_time timestamp(3) default CURRENT_TIMESTAMP(3) not null,
    update_time timestamp(3) null on update CURRENT_TIMESTAMP(3),
    create_user varchar(40) null,
    update_user varchar(40) null,
    ver int default 1 not null
) charset = utf8mb4;