USE msghub;

create table if not exists archive_boxed_message (
    id bigint unsigned auto_increment primary key,
    created_time datetime not null,
    updated_time datetime not null,
    member_id varchar(36) null comment 'JKOS ID',
    content text null comment 'boxed_message gzip base64 後的內容',
    INDEX idx_member_id (member_id),
    INDEX idx_created_time (created_time)
) charset = utf8mb4;

create table if not exists biz_message_id_tab (
    id bigint unsigned auto_increment primary key,
    biz_message_id bigint unsigned null
);

create table if not exists biz_message_tab (
    id bigint unsigned auto_increment primary key,
    biz_message_id bigint unsigned null,
    biz_message_status varchar(16) not null,
    type varchar(16) not null,
    message_template_id bigint unsigned null,
    jkos_id varchar(64) not null,
    device_token varchar(256) not null,
    topic_id varchar(64) not null,
    push_title varchar(64) not null,
    push_content varchar(256) not null,
    push_biz_data text null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    constraint idx_biz_message_id unique (biz_message_id),
    INDEX idx_message_template_id (message_template_id)
);

create table if not exists boxed_message (
    id bigint unsigned auto_increment primary key,
    created_time datetime not null,
    updated_time datetime not null,
    message_title varchar(32) charset utf8 not null comment '訊息匣標題',
    message_content varchar(1024) charset utf8 not null comment '訊息匣內容',
    redirect_info varchar(1024) charset utf8 null comment 'App 轉導用資料',
    member_id varchar(36) null comment 'JKOS ID',
    target int not null comment '目標類型, 請參照 BoxedMessageTargetType',
    tag_type int not null comment '標籤類型, App 用於顯示顏色、判斷頁面行為',
    behavior_type int not null comment '標籤類型, App 用於判斷頁面行為',
    boxed_message_template_id varchar(64) null comment '對應的 template Id, 用於更新',
    INDEX idx_boxed_message_template_id (boxed_message_template_id),
    INDEX idx_created_time (created_time),
    INDEX idx_member_id (member_id),
    INDEX idx_target_tagType_memberId (target, tag_type, member_id)
) charset = utf8mb4;

create table if not exists boxed_message_id_tab (
    id bigint unsigned auto_increment primary key,
    boxed_message_id bigint unsigned null
) charset = utf8mb4;

create table if not exists boxed_message_template_id_tab (
    id bigint unsigned auto_increment primary key,
    boxed_message_template_id bigint unsigned null
) charset = utf8mb4;

create table if not exists boxed_message_template_tab (
    id bigint unsigned auto_increment primary key,
    boxed_message_template_id varchar(64) charset utf8 not null,
    jkos_id_list varchar(20480) charset utf8 not null,
    title_template text not null,
    content_template text not null,
    type tinyint not null,
    behavior tinyint not null,
    behavior_key varchar(512) charset utf8 null,
    biz_info varchar(256) charset utf8 not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    message_setting_template_id varchar(64) null,
    constraint idx_boxed_message_template_id unique (boxed_message_template_id),
    INDEX idx_message_setting_template_id (message_setting_template_id)
) charset = utf8mb4;

create table if not exists file_info (
    id bigint unsigned auto_increment primary key,
    file_type tinyint not null,
    file_name varchar(64) null,
    tag_id varchar(64) null,
    created_time timestamp(3) default CURRENT_TIMESTAMP(3) not null on update CURRENT_TIMESTAMP(3),
    updated_time timestamp(3) null
) charset = utf8mb4;

create table if not exists file_info_id_tab (
    id bigint unsigned auto_increment primary key,
    file_info_id bigint unsigned null
);

create table if not exists file_info_tab (
    id bigint unsigned auto_increment primary key,
    file_info_id varchar(64) not null,
    file_type tinyint not null,
    storage_path varchar(64) not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    constraint idx_file_info_id unique (file_info_id)
);

create table if not exists instant_task_id_tab (
    id bigint unsigned auto_increment primary key,
    instant_task_id bigint unsigned null
);

create table if not exists instant_task_tab (
    id bigint unsigned auto_increment primary key,
    instant_task_id bigint unsigned null,
    biz_message_id bigint unsigned null,
    status varchar(16) not null,
    handled_count bigint unsigned not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    constraint idx_instant_task_id unique (instant_task_id),
    INDEX idx_biz_message_id (biz_message_id)
);

create table if not exists jkos_device_token_tab (
    id bigint unsigned auto_increment primary key,
    jkos_id varchar(64) not null,
    device_token varchar(256) not null,
    constraint idx_jkos_id unique (jkos_id)
);

create table if not exists message_setting_template_id_tab (
    id bigint unsigned auto_increment primary key,
    message_setting_template_id bigint unsigned null
);

create table if not exists message_setting_template_tab (
    id bigint unsigned auto_increment primary key,
    message_setting_template_id varchar(64) not null,
    message_type tinyint not null,
    message_to_type tinyint not null,
    file_id varchar(64) null,
    platform_type int default 1 null,
    biz_info varchar(256) not null,
    boxed_message_title text null,
    boxed_message_content text null,
    boxed_message_tag tinyint null,
    push_notification_title text null,
    push_notification_content text null,
    web_url varchar(512) null,
    sent_type tinyint not null,
    message_sent_status tinyint not null,
    dispatch_count bigint unsigned null,
    boxed_message_hit_count bigint unsigned null,
    notification_hit_count bigint unsigned null,
    boxed_message_sent_count bigint unsigned null,
    push_notification_sent_count bigint unsigned null,
    sent_push_notification_task tinyint(1) not null,
    sent_at timestamp(3) null,
    finish_at timestamp(3) null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    scheduled_start_at timestamp null,
    ios_all int default 0 null,
    ios_app_version varchar(100) null,
    android_all int default 0 null,
    android_app_version varchar(100) null,
    is_deleted tinyint(1) default 0 null,
    push_notification_success_count bigint unsigned default 0 null,
    notification_web_url varchar(512) null,
    test_mode tinyint(1) default 0 null,
    sending_speed bigint unsigned default 0 null,
    constraint idx_message_setting_template_id unique (message_setting_template_id),
    INDEX idx_message_sent_status (message_sent_status),
    INDEX idx_platform_type (platform_type)
);

create table if not exists message_template_id_tab (
    id bigint unsigned auto_increment primary key,
    message_template_id bigint unsigned null
);

create table if not exists message_template_tab (
    id bigint unsigned auto_increment primary key,
    message_template_id bigint unsigned null,
    jkos_id_list mediumtext not null,
    push_title_template varchar(64) not null,
    push_content_template varchar(256) not null,
    push_biz_data text null,
    biz_info varchar(256) not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    message_setting_template_id varchar(64) not null,
    constraint idx_message_template_id unique (message_template_id),
    INDEX idx_message_setting_template_id (message_setting_template_id)
);

create table if not exists notification_id_tab (
    id bigint unsigned auto_increment primary key,
    notification_id bigint unsigned null
);

create table if not exists retry_event (
    id bigint auto_increment comment 'PK' primary key,
    event_type int not null comment '事件類型',
    content varchar(3072) charset utf8 not null comment 'event json',
    retry_status int not null comment '處理狀態',
    created_time timestamp(3) default CURRENT_TIMESTAMP(3) not null comment '建立時間',
    updated_time timestamp(3) default CURRENT_TIMESTAMP(3) not null comment '更新時間',
    INDEX idx_retry_status (retry_status)
) charset = utf8mb4;

create table if not exists scheduled_task_id_tab (
    id bigint unsigned auto_increment primary key,
    scheduled_task_id bigint unsigned null
);

create table if not exists scheduled_task_tab (
    id bigint unsigned auto_increment primary key,
    scheduled_task_id bigint unsigned null,
    biz_message_id bigint unsigned null,
    scheduled_task_status varchar(16) not null,
    schedule_start_time timestamp(3) null,
    schedule_end_time timestamp(3) null,
    handled_count bigint unsigned not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    scheduled_entity_id varchar(64) null,
    scheduled_entity_id_type varchar(64) null,
    constraint idx_scheduled_task_id unique (scheduled_task_id),
    INDEX idx_biz_message_id (biz_message_id),
    INDEX idx_schedule_start_time (schedule_start_time),
    INDEX idx_status_start_time (
        scheduled_task_status,
        schedule_start_time
    )
);

create table if not exists sms_setting (
    id bigint unsigned auto_increment primary key,
    s_key varchar(64) collate utf8mb4_unicode_ci not null,
    s_value varchar(64) collate utf8mb4_unicode_ci not null,
    s_group varchar(64) collate utf8mb4_unicode_ci not null
) charset = utf8mb4;

create table if not exists topic_id_tab (
    id bigint unsigned auto_increment primary key,
    topic_id bigint unsigned null
);

create table if not exists topic_subscription_tab (
    id bigint unsigned auto_increment primary key,
    topic_id varchar(64) default '' not null,
    jkos_id varchar(64) default '' not null,
    device_token varchar(256) default '' not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    constraint idx_topic_id_jkos_id unique (topic_id, jkos_id)
);

create table if not exists topic_tab (
    id bigint unsigned auto_increment primary key,
    topic_id varchar(64) null,
    topic_name varchar(64) default '' not null,
    created_time timestamp(3) null,
    updated_time timestamp(3) null,
    constraint idx_topic_id unique (topic_id)
);