// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

#import "Constants.h"

@implementation Constants

#pragma mark Google Analytics.
NSString *const GOOGLE_ANALYTICS_ID = @"UA-26262162-3";
#pragma mark -

#pragma mark App Version
NSString *const GIT_COMMIT = @"GIT_COMMIT";
NSString *const APP_VERSION = @"CFBundleVersion";
#pragma mark -

#pragma mark Service URLs.
NSString *const READ_ME_URL = @"/khcrest/v2/user/me";
NSString *const READ_ME_AVATAR_URL = @"/khcrest/v2/user/me/avatar";
NSString *const CREATE_CHANNEL_URL = @"/khcrest/v2/channel";
NSString *const SEND_COMMAND_URL = @"/khcrest/v2/command";
NSString *const READ_COMMAND_URL = @"/khcrest/v2/command";
NSString *const READ_MESSAGE_URL = @"/khcrest/v2/message";
NSString *const AVATAR_URL = @"avatar";
NSString *const CONTENT_URL = @"content";
NSString *const THUMBNAIL_URL = @"thumbnail";
NSString *const READ_ACCOUNT_URL = @"/khcrest/v2/account";
NSString *const INFO_URL = @"info";
NSString *const USER_AUTOREGISTER_URL = @"/khcrest/v2/account";
NSString *const USER_URL = @"user";
NSString *const READ_GROUP_URL = @"/khcrest/v2/group";
NSString *const LOG_URL = @"log";
NSString *const SEND_TRANSACTION_URL = @"/khcrest/v2/command/transaction";
NSString *const WEBSOCKET_URL = @"/khcrest/sync";
NSString *const READ_CONTACT_URL = @"/khcrest/v2/user";
NSString *const CONTACT_URL = @"contact";
NSString *const PASSWORD_RESET_REQUEST_URL = @"/khcrest/v2/password/code";
NSString *const PASSWORD_RESET_URL = @"/khcrest/v2/password/reset";
NSString *const ROOM_URL = @"https://m01f66039.apps.nubomedia-paas.eu/room";
#pragma mark -

#pragma mark Pojo Keys.
NSString *const ID_KEY = @"id";
NSString *const USERNAME_KEY = @"username";
NSString *const NAME_KEY = @"name";
NSString *const SURNAME_KEY = @"surname";
NSString *const PICTURE_KEY = @"picture";
NSString *const PHONE_KEY = @"phone";
NSString *const EMAIL_KEY = @"email";
NSString *const IDENT_KEY = @"ident";
NSString *const USER_ID_KEY = @"userId";
NSString *const REGISTER_ID_KEY = @"registerId";
NSString *const REGISTER_TYPE_KEY = @"registerType";
NSString *const CHANNEL_ID_KEY = @"channelId";
NSString *const METHOD_KEY = @"method";
NSString *const PARAMS_KEY = @"params";
NSString *const COMMAND_ID_KEY = @"commandId";
NSString *const SEQUENCE_NUMBER_KEY = @"sequenceNumber";
NSString *const CAN_LEAVE_KEY = @"canLeave";
NSString *const ADMIN_KEY = @"admin";
NSString *const OWNER_KEY = @"ownerId";
NSString *const PARTY_KEY = @"party";
NSString *const TYPE_KEY = @"type";
NSString *const LOCAL_ID_KEY = @"localId";
NSString *const TIMESTAMP_KEY = @"timestamp";
NSString *const FROM_KEY = @"from";
NSString *const TIMELINE_KEY = @"timeline";
NSString *const TIMELINE_ID_KEY = @"timelineId";
NSString *const BODY_KEY = @"body";
NSString *const CONTENT_KEY = @"content";
NSString *const CONTENT_SIZE_KEY = @"contentSize";
NSString *const CONTENT_TYPE_KEY = @"contentType";
NSString *const ACK_KEY = @"ack";
NSString *const PASSWORD_KEY = @"password";
NSString *const TO_KEY = @"to";
NSString *const USER_AUTOREGISTER_KEY = @"userAutoregister";
NSString *const GROUP_AUTOREGISTER_KEY = @"groupAutoregister";
NSString *const ACCOUNT_KEY = @"account";
NSString *const GROUP_KEY = @"group";
NSString *const USER_KEY = @"user";
NSString *const OWNER_ID_KEY = @"ownerId";
NSString *const ENABLED_KEY = @"enabled";
NSString *const LAST_TIMESTAMP_KEY = @"lastTimestamp";
NSString *const PHONE_REGION_KEY = @"phoneRegion";
NSString *const ATTACHMENT_SIZE_KEY = @"attachmentSize";
NSString *const INSTANCE_ID_KEY = @"instanceId";
NSString *const LOCAL_PHONES_KEY = @"localPhones";
NSString *const UUID_KEY = @"uuid";
NSString *const ENTITY_KEY = @"entity";
NSString *const FILTER_KEY = @"filter";
NSString *const QUERY_KEY = @"query";
NSString *const LOCALE_KEY = @"locale";
NSString *const USER_IDENTITY_KEY = @"userIdentity";
NSString *const SECURITY_CODE_KEY = @"securityCode";
NSString *const NEW_PASSWORD_KEY = @"newPassword";
#pragma mark -

#pragma mark JSONRPC Keys.
NSString *const JSONRPC_KEY = @"jsonrpc";
NSString *const CODE_KEY = @"code";
NSString *const RESULT_KEY = @"result";
NSString *const ERROR_KEY = @"error";
#pragma mark -

#pragma mark HTTP Methods.
NSString *const HTTP_PROTOCOL = @"http";
NSString *const HTTPS_PROTOCOL = @"https";
NSString *const GET_HTTP_METHOD = @"GET";
NSString *const POST_HTTP_METHOD = @"POST";
NSString *const DELETE_HTTP_METHOD = @"DELETE";
#pragma mark -

#pragma mark HTTP Headers.
NSString *const SET_COOKIE_HDR = @"Set-Cookie";
NSString *const COOKIE_HDR = @"Cookie";
NSString *const CONTENT_TYPE_HDR = @"Content-Type";
NSString *const CONTENT_LENGTH_HDR = @"Content-Length";
NSString *const CONTENT_DISPOSITION_HDR = @"Content-Disposition";
NSString *const CONTENT_TRANSFER_ENCODING_HDR = @"Content-Transfer-Encoding";
#pragma mark -

#pragma mark Content-Type
NSString *const JSON_TYPE = @"application/json";
NSString *const MULTIPART_TYPE = @"multipart/form-data";
NSString *const CHARSET_TYPE = @"charset=";
NSString *const IMAGE_JPEG_TYPE = @"image/jpeg";
NSString *const VIDEO_QUICKTIME_TYPE = @"video/quicktime";
#pragma mark -

#pragma mark Content-Disposition.
NSString *const FORM_DATA_TYPE = @"form-data";
NSString *const NAME_TYPE = @"name=";
NSString *const NAME_COMMAND_TYPE = @"command";
NSString *const NAME_CONTENT_TYPE = @"content";
NSString *const NAME_USER_TYPE = @"user";
NSString *const NAME_PICTURE_TYPE = @"picture";
#pragma mark -

#pragma mark Content-Transfer-Encoding.
NSString *const BINARY_TYPE = @"binary";
#pragma mark -

#pragma mark Other Constants.
NSString *const APNS_SERVICE = @"apns";
NSString *const CRLF = @"\r\n";
NSString *const UTF_8 = @"UTF-8";
NSString *const KEYCHAIN_PASSWORD_KEY = @"password";
NSString *const KEYCHAIN_COOKIE_KEY = @"cookie";
NSString *const MEDIA_TYPE_IMAGE = @"image";
NSString *const MEDIA_TYPE_VIDEO = @"video";
NSString *const MEDIA_IOS_FOLDER = @"KHC";
NSString *const ADMIN_TEXTVIEW = @"Admin";
NSString *const CREDENTIALS_VIEW_ID = @"CredentialsViewController";
NSString *const INITIAL_TABBAR_ID = @"InitialTabBarController";
NSString *const APNS_TOKEN = @"apnsToken";
NSString *const SEQUENCE_NUMBER_0 = @"0";
NSString *const ZERO_STRING = @"0";
NSNumber *const ZERO_NUMBER = 0;
NSString *const PHONE_REGION_ES = @"ES";
NSString *const EASTER_EGG_TEXT = @"kurento666";
NSString *const EXTENSION_TYPE_PNG = @"png";
NSString *const EXTENSION_TYPE_MOV = @"mov";
NSString *const TEMP_FILE_M4V = @"temp.m4v";
int const REFRESH_MESSAGE_NUMBER = 50;
#pragma mark -

#pragma mark Command Methods
NSString *const FACTORY_RESET_METHOD = @"factoryReset";
NSString *const UPDATE_GROUP_METHOD = @"updateGroup";
NSString *const UPDATE_TIMELINE_METHOD = @"updateTimeline";
NSString *const UPDATE_MESSAGE_METHOD = @"updateMessage";
NSString *const UPDATE_CONTACT_METHOD = @"updateContact";
NSString *const UPDATE_USER_METHOD = @"updateUser";
NSString *const SEND_MESSAGE_TO_GROUP_METHOD = @"sendMessageToGroup";
NSString *const SEND_MESSAGE_TO_USER_METHOD = @"sendMessageToUser";
NSString *const CREATE_GROUP_METHOD = @"createGroup";
NSString *const DELETE_GROUP_METHOD = @"deleteGroup";
NSString *const REMOVE_GROUP_MEMBER_METHOD = @"removeGroupMember";
NSString *const ADD_GROUP_MEMBER_METHOD = @"addGroupMember";
NSString *const ADD_GROUP_ADMIN_METHOD = @"addGroupAdmin";
NSString *const REMOVE_GROUP_ADMIN_METHOD = @"removeGroupAdmin";
NSString *const DELETE_TIMELINE_METHOD = @"deleteTimeline";
NSString *const CREATE_TIMELINE_METHOD = @"createTimeline";
NSString *const SEARCH_LOCAL_CONTACT_METHOD = @"searchLocalContact";
#pragma mark -

#pragma mark Entity Names.
NSString *const USER_ME_ENTITY = @"UserMe";
NSString *const GROUP_ENTITY = @"Group";
NSString *const TIMELINE_ENTITY = @"Timeline";
NSString *const MESSAGE_ENTITY = @"Message";
NSString *const CONTACT_ENTITY = @"Contact";
NSString *const AVATAR_ENTITY = @"Avatar";
NSString *const THUMBNAIL_ENTITY = @"Thumbnail";
NSString *const COMMAND_ENTITY = @"Command";
NSString *const ORDERED_COMMANDS_ENTITY = @"OrderedCommands";
#pragma mark -

#pragma mark Notification Names.
NSString *const READ_COMMAND_FINISH_NOTIFICATION = @"readCommandFinished";
NSString *const SEND_COMMAND_FINISH_NOTIFICATION = @"sendCommandFinished";
NSString *const TIMELINE_UPDATED_NOTIFICATION = @"timelineUpdated";
NSString *const MESSAGE_UPDATED_NOTIFICATION = @"messageUpdated";
NSString *const AVATAR_UPDATED_NOTIFICATION = @"avatarUpdated";
NSString *const THUMBNAIL_UPDATED_NOTIFICATION = @"thumbnailUpdated";
NSString *const UPLOAD_UPDATED_NOTIFICATION = @"uploadUpdated";
NSString *const GROUP_UPDATED_NOTIFICATION = @"groupUpdated";
NSString *const TIMELINE_DELETED_NOTIFICATION = @"timelineDeleted";
NSString *const USER_UPDATED_NOTIFICATION = @"userUpdated";
NSString *const READ_ACCOUNT_FAILED_NOTIFICATION = @"accountFailed";
NSString *const READ_ACCOUNT_SUCCESSFUL_NOTIFICATION = @"accountSuccessful";
NSString *const READ_ME_SUCCESSFUL_NOTIFICATION = @"readMeSuccessful";
NSString *const READ_ME_FAILED_NOTIFICATION = @"readMeFailed";
NSString *const READ_ME_AVATAR_SUCCESSFUL_NOTIFICATION = @"readMeAvatarSuccessful";
NSString *const READ_ME_AVATAR_FAILED_NOTIFICATION = @"readMeAvatarFailed";
NSString *const READ_COMMAND_SUCCESSFUL_NOTIFICATION = @"readCommandSuccessful";
NSString *const READ_COMMAND_FAILED_NOTIFICATION = @"readCommandFailed";
NSString *const READ_MESSAGE_AVATAR_SUCCESSFUL_NOTIFICATION = @"readMessageAvatarSuccessful";
NSString *const READ_MESSAGE_AVATAR_FAILED_NOTIFICATION = @"readMessageAvatarFailed";
NSString *const READ_MESSAGE_CONTENT_SUCCESSFUL_NOTIFICATION = @"readMessageContentSuccessful";
NSString *const READ_MESSAGE_CONTENT_FAILED_NOTIFICATION = @"readMessageContentFailed";
NSString *const READ_MESSAGE_THUMBNAIL_SUCCESSFUL_NOTIFICATION = @"readMessageThumbnailSuccessful";
NSString *const READ_MESSAGE_THUMBNAIL_FAILED_NOTIFICATION = @"readMessageThumbnailFailed";
NSString *const READ_GROUP_AVATAR_SUCCESSFUL_NOTIFICATION = @"readGroupAvatarSuccessful";
NSString *const READ_GROUP_AVATAR_FAILED_NOTIFICATION = @"readGroupAvatarFailed";
NSString *const CREATE_CHANNEL_SUCCESSFUL_NOTIFICATION = @"createChannelSuccessful";
NSString *const CREATE_CHANNEL_FAILED_NOTIFICATION = @"createChannelFailed";
NSString *const USER_AUTOREGISTER_SUCCESSFUL_NOTIFICATION = @"userAutoregisterSuccessful";
NSString *const USER_AUTOREGISTER_FAILED_NOTIFICATION = @"userAutoregisterFailed";
NSString *const DELETE_CHANNEL_SUCCESSFUL_NOTIFICATION = @"deleteChannelSuccessful";
NSString *const DELETE_CHANNEL_FAILED_NOTIFICATION = @"deleteChannelFailed";
NSString *const SEND_COMMAND_SUCCESSFUL_NOTIFICATION = @"sendCommandSuccessful";
NSString *const SEND_COMMAND_FAILED_NOTIFICATION = @"sendCommandFailed";
NSString *const SEND_LOG_SUCCESSFUL_NOTIFICATION = @"sendLogSuccessful";
NSString *const SEND_LOG_FAILED_NOTIFICATION = @"sendLogFailed";
NSString *const SEND_TRANSACTION_SUCCESSFUL_NOTIFICATION = @"sendTransactionSuccessful";
NSString *const SEND_TRANSACTION_FAILED_NOTIFICATION = @"sendTransactionFailed";
NSString *const READ_MESSAGE_SUCCESSFUL_NOTIFICATION = @"readMessageSuccessful";
NSString *const READ_MESSAGE_FAILED_NOTIFICATION = @"readMessageFailed";
NSString *const PASSWORD_RESET_REQUEST_SUCCESSFUL_NOTIFICATION = @"passwordResetRequestSuccessful";
NSString *const PASSWORD_RESET_REQUEST_FAILED_NOTIFICATION = @"passwordResetRequsetFailed";
NSString *const PASSWORD_RESET_SUCCESSFUL_NOTIFICATION = @"passwordResetSuccessful";
NSString *const PASSWORD_RESET_FAILED_NOTIFICATION = @"passwordResetFailed";
#pragma mark -

#pragma mark Segue Names.
NSString *const TIMELINE_SEGUE = @"timelineSegue";
NSString *const REGISTER_SEGUE = @"registerSegue";
NSString *const EDIT_GROUP_SEGUE = @"editGroupSegue";
NSString *const ADD_CONTACT_SEGUE = @"addContactSegue";
NSString *const SETTINGS_SEGUE = @"settingsSegue";
NSString *const EASTER_EGG_SEGUE = @"easterEggSegue";
NSString *const LOGOUT_SEGUE = @"logoutSegue";
NSString *const RECOVER_PASSWORD_SEGUE = @"recoverPasswordSegue";
NSString *const CREDENTIALS_SEGUE = @"credentialsViewSegue";
#pragma mark -

#pragma mark Cell Names.
NSString *const HOME_CELL = @"HomeCustomCell";
NSString *const TIMELINE_TEXT_CELL = @"TimelineCustomCell";
NSString *const TIMELINE_MEDIA_CELL = @"TimelineMediaCustom";
NSString *const TIMELINE_BOTTOM_CELL = @"TimelineBottomCustom";
NSString *const ADDRESS_CELL = @"GroupCell";
NSString *const GROUP_MEMBER_CELL = @"memberCell";
NSString *const ADD_MEMBER_CELL = @"addMemberCell";
#pragma mark -

#pragma mark Image Names.
NSString *const IMAGE_CAMERA = @"camera_hdpi.png";
NSString *const IMAGE_VIDEO = @"video_hdpi.png";
NSString *const IMAGE_GALLERY = @"gallery_hdpi.png";
NSString *const IMAGE_DROP_DOWN = @"dropDown.png";
NSString *const IMAGE_DROP_UP = @"dropUp.png";
NSString *const IMAGE_ATTACH = @"attach_hdpi.png";
NSString *const IMAGE_SEND = @"send_hdpi.png";
NSString *const IMAGE_ADMIN = @"administrator.png";
NSString *const GROUP_IMAGE = @"group_hdpi.png";
NSString *const IMAGE_EDIT = @"edit_light.png";
NSString *const IMAGE_SAVE = @"save_light.png";
NSString *const IMAGE_CANCEL = @"cancel_light.png";
NSString *const IMAGE_ADD_CONTACT = @"addContact_white.png";
NSString *const IMAGE_REMOVE_CONTACT = @"remove_user_white.png";
NSString *const IMAGE_PERSON = @"person_hdpi.png";
NSString *const IMAGE_SETTINGS_LIGHT = @"settings_light.png";
NSString *const IMAGE_BG = @"bg.png";
NSString *const IMAGE_MESSAGE_STATUS_GRAY = @"bg_status_grey.png";
NSString *const IMAGE_MESSAGE_STATUS_GREEN = @"bg_status_green.png";
NSString *const IMAGE_KURENTO = @"kurentoRound.png";
NSString *const IMAGE_CALL = @"ic_call.png";
NSString *const IMAGE_CALL_LIGHT = @"ic_call_light.png";
#pragma mark -

#pragma mark Thumbnail Sizes.
NSString *const THUMBNAIL_SIZE_SMALL = @"small";
NSString *const THUMBNAIL_SIZE_MEDIUM = @"medium";
NSString *const THUMBNAIL_SIZE_LARGE = @"large";
#pragma mark -

#pragma mark User Default Keys.
NSString *const ACCOUNT_NAME_KEY = @"accountName";
NSString *const ACCOUNT_USER_AUTOREGISTER_KEY = @"userAutoregister";
NSString *const ACCOUNT_GROUP_AUTOREGISTER_KEY = @"groupAutoregister";
NSString *const LASTSEQUENCE_KEY = @"lastSequence";
#pragma mark -

#pragma mark Xib File Names.
NSString *const DOWNLOADED_IMAGE_XIB = @"DownloadedImage";
NSString *const REGISTER_GROUP_XIB = @"RegisterGroup";
#pragma mark -

#pragma mark Settings Names.
NSString *const SETTINGS_RESOURCE = @"Settings";
NSString *const SETTINGS_TYPE = @"bundle";
NSString *const SETTINGS_PLIST = @"Root.plist";
NSString *const SETTINGS_PREFERENCES = @"PreferenceSpecifiers";
NSString *const SETTINGS_KEY = @"Key";
NSString *const SETTINGS_VALUE = @"DefaultValue";
NSString *const SETTINGS_PROTOCOL = @"BASE_PROTOCOL";
NSString *const SETTINGS_URL = @"BASE_URL";
NSString *const SETTINGS_PORT = @"BASE_PORT";
NSString *const SETTINGS_ACCOUNT = @"ACCOUNT_ID";
NSString *const SETTINGS_MAX_MESSAGES = @"MAX_MESSAGES";
NSString *const SETTINGS_MAX_SPACE = @"MAX_SPACE";
#pragma mark -

#pragma mark Lifecycle states.
NSString *const STATE_LOCAL = @"local";
NSString *const STATE_ACTIVE = @"active";
NSString *const STATE_DELETED = @"deleted";
NSString *const STATE_ENABLED = @"enabled";
NSString *const STATE_DISABLED = @"disabled";
NSString *const STATE_INACTIVE = @"inactive";
NSString *const STATE_NEW_MINE = @"new_mine";
NSString *const STATE_NEW_OTHER = @"new_other";
#pragma mark -

#pragma mark Test Monitor States
NSString *const MSG_USR_CREATE = @"MSG_USER_CREATE";
NSString *const CMD_SEND_REQ_START = @"CMD_SEND_REQUEST_START";
NSString *const CMD_SEND_REQ_FINISH = @"CMD_SEND_REQUEST_FINISH";
NSString *const MSG_RECV = @"MSG_RECEIVED";
NSString *const CMD_ENQUEUE = @"CMD_ENQUEUE";
NSString *const CMD_DEQUEUE = @"CMD_DEQUEUE";
#pragma mark -

#pragma mark JsonRPC
NSString *const JSONRPC_VERSION = @"2.0";
NSString *const JSONRPC_METHOD_REGISTER = @"REGISTER";
NSString *const JSONRPC_CODE_OK = @"OK";
NSString *const JSONRPC_CODE_PARSE_ERROR = @"PARSE_ERROR";
NSString *const JSONRPC_METHOD_SYNC = @"SYNC";
#pragma mark -

#pragma mark 404 Codes
NSString *const CHANNEL_NOT_FOUND_404 = @"CHANNEL_NOT_FOUND";
NSString *const SYNCHRONIZATION_IGNORE_404 = @"SYNCHRONIZATION_IGNORE";
NSString *const SYNCHRONIZATION_ERROR_404 = @"SYNCHRONIZATION_ERROR";
#pragma mark -

#pragma mark Screen Names
NSString *const CREDENTIALS_VIEW = @"Credentials View";
NSString *const REGISTER_VIEW = @"Register View";
NSString *const PROFILE_VIEW = @"Profile View";
NSString *const HOME_VIEW = @"Home View";
NSString *const ADDRESS_BOOK_VIEW = @"Address Book View";
NSString *const TIMELINE_VIEW = @"Timeline View";
NSString *const EDIT_GROUP_VIEW = @"Edit Group View";
NSString *const ADD_GROUP_MEMBER_VIEW = @"Add Group Member View";
NSString *const SETTINGS_VIEW = @"Settings View";
NSString *const EASTER_EGG_VIEW = @"Easter Egg View";
#pragma mark -

#pragma mark REST Services Names
NSString *const READ_ME_TYPE = @"Read_Me";
NSString *const READ_ME_AVATAR_TYPE = @"Read_Me_Avatar";
NSString *const READ_ACCOUNT_INFO_TYPE = @"Read_Account_Info";
NSString *const READ_COMMAND_TYPE = @"Read_Command";
NSString *const READ_MESSAGE_AVATAR_TYPE = @"Read_Message_Avatar";
NSString *const READ_MESSAGE_CONTENT_TYPE = @"Read_Message_Content";
NSString *const READ_MESSAGE_THUMBNAIL_TYPE = @"Read_Message_Thumbnail";
NSString *const READ_GROUP_AVATAR_TYPE = @"Read_Group_Avatar";
NSString *const CREATE_CHANNEL_TYPE = @"Create_Channel";
NSString *const USER_AUTOREGISTER_TYPE = @"User_Autoregister";
NSString *const DELETE_CHANNEL_TYPE = @"Delete_Channel";
NSString *const SEND_COMMAND_TYPE = @"Send_Command";
NSString *const SEND_LOG_TYPE = @"Send_Log";
NSString *const SEND_TRANSACTION_TYPE = @"Send_Transaction";
NSString *const READ_MESSAGE_TYPE = @"Read_Message";
NSString *const READ_CONTACT_AVATAR_TYPE = @"Read_Contact_Avatar";
NSString *const PASSWORD_RESET_REQUEST_TYPE = @"Password_Reset_Request";
NSString *const PASSWORD_RESET_TYPE = @"Password_Reset";
NSString *const UNDEFINED_TYPE = @"Undefined";
#pragma mark -

@end
