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

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#pragma mark Google Analytics.
extern NSString *const GOOGLE_ANALYTICS_ID;
#pragma mark -

#pragma mark App Version
extern NSString *const GIT_COMMIT;
extern NSString *const APP_VERSION;
#pragma mark -

#pragma mark Service URLs.
extern NSString *const READ_ME_URL;
extern NSString *const READ_ME_AVATAR_URL;
extern NSString *const CREATE_CHANNEL_URL;
extern NSString *const SEND_COMMAND_URL;
extern NSString *const READ_COMMAND_URL;
extern NSString *const READ_MESSAGE_URL;
extern NSString *const AVATAR_URL;
extern NSString *const CONTENT_URL;
extern NSString *const THUMBNAIL_URL;
extern NSString *const READ_ACCOUNT_URL;
extern NSString *const INFO_URL;
extern NSString *const USER_AUTOREGISTER_URL;
extern NSString *const USER_URL;
extern NSString *const READ_GROUP_URL;
extern NSString *const LOG_URL;
extern NSString *const SEND_TRANSACTION_URL;
extern NSString *const WEBSOCKET_URL;
extern NSString *const READ_CONTACT_URL;
extern NSString *const CONTACT_URL;
extern NSString *const PASSWORD_RESET_REQUEST_URL;
extern NSString *const PASSWORD_RESET_URL;
extern NSString *const ROOM_URL;
#pragma mark -

#pragma mark Pojo Keys.
extern NSString *const ID_KEY;
extern NSString *const USERNAME_KEY;
extern NSString *const NAME_KEY;
extern NSString *const SURNAME_KEY;
extern NSString *const PICTURE_KEY;
extern NSString *const PHONE_KEY;
extern NSString *const EMAIL_KEY;
extern NSString *const IDENT_KEY;
extern NSString *const USER_ID_KEY;
extern NSString *const REGISTER_ID_KEY;
extern NSString *const REGISTER_TYPE_KEY;
extern NSString *const CHANNEL_ID_KEY;
extern NSString *const METHOD_KEY;
extern NSString *const PARAMS_KEY;
extern NSString *const COMMAND_ID_KEY;
extern NSString *const SEQUENCE_NUMBER_KEY;
extern NSString *const CAN_SEND_KEY;
extern NSString *const CAN_READ_KEY;
extern NSString *const CAN_LEAVE_KEY;
extern NSString *const ADMIN_KEY;
extern NSString *const OWNER_KEY;
extern NSString *const PARTY_KEY;
extern NSString *const TYPE_KEY;
extern NSString *const LOCAL_ID_KEY;
extern NSString *const TIMESTAMP_KEY;
extern NSString *const FROM_KEY;
extern NSString *const TIMELINE_KEY;
extern NSString *const TIMELINE_ID_KEY;
extern NSString *const BODY_KEY;
extern NSString *const CONTENT_KEY;
extern NSString *const CONTENT_SIZE_KEY;
extern NSString *const CONTENT_TYPE_KEY;
extern NSString *const ACK_KEY;
extern NSString *const PASSWORD_KEY;
extern NSString *const TO_KEY;
extern NSString *const VIEWERS_KEY;
extern NSString *const USER_AUTOREGISTER_KEY;
extern NSString *const GROUP_AUTOREGISTER_KEY;
extern NSString *const ACCOUNT_KEY;
extern NSString *const GROUP_KEY;
extern NSString *const USER_KEY;
extern NSString *const OWNER_ID_KEY;
extern NSString *const ENABLED_KEY;
extern NSString *const LAST_TIMESTAMP_KEY;
extern NSString *const PHONE_REGION_KEY;
extern NSString *const ATTACHMENT_SIZE_KEY;
extern NSString *const INSTANCE_ID_KEY;
extern NSString *const LOCAL_PHONES_KEY;
extern NSString *const UUID_KEY;
extern NSString *const ENTITY_KEY;
extern NSString *const FILTER_KEY;
extern NSString *const QUERY_KEY;
extern NSString *const LOCALE_KEY;
extern NSString *const USER_IDENTITY_KEY;
extern NSString *const SECURITY_CODE_KEY;
extern NSString *const NEW_PASSWORD_KEY;
#pragma mark -

#pragma mark JSONRPC Keys.
extern NSString *const JSONRPC_KEY;
extern NSString *const CODE_KEY;
extern NSString *const RESULT_KEY;
extern NSString *const ERROR_KEY;
#pragma mark -

#pragma mark HTTP Methods.
extern NSString *const HTTP_PROTOCOL;
extern NSString *const HTTPS_PROTOCOL;
extern NSString *const GET_HTTP_METHOD;
extern NSString *const POST_HTTP_METHOD;
extern NSString *const DELETE_HTTP_METHOD;
#pragma mark -

#pragma mark HTTP Headers.
extern NSString *const SET_COOKIE_HDR;
extern NSString *const COOKIE_HDR;
extern NSString *const CONTENT_TYPE_HDR;
extern NSString *const CONTENT_LENGTH_HDR;
extern NSString *const CONTENT_DISPOSITION_HDR;
extern NSString *const CONTENT_TRANSFER_ENCODING_HDR;
#pragma mark -

#pragma mark Content-Type.
extern NSString *const JSON_TYPE;
extern NSString *const MULTIPART_TYPE;
extern NSString *const CHARSET_TYPE;
extern NSString *const IMAGE_JPEG_TYPE;
extern NSString *const VIDEO_QUICKTIME_TYPE;
#pragma mark -

#pragma mark Content-Disposition.
extern NSString *const FORM_DATA_TYPE;
extern NSString *const NAME_TYPE;
extern NSString *const NAME_COMMAND_TYPE;
extern NSString *const NAME_CONTENT_TYPE;
extern NSString *const NAME_USER_TYPE;
extern NSString *const NAME_PICTURE_TYPE;
#pragma mark -

#pragma mark Content-Transfer-Encoding.
extern NSString *const BINARY_TYPE;
#pragma mark -

#pragma mark Other Constants.
extern NSString *const APNS_SERVICE;
extern NSString *const CRLF;
extern NSString *const UTF_8;
extern NSString *const KEYCHAIN_PASSWORD_KEY;
extern NSString *const KEYCHAIN_COOKIE_KEY;
extern NSString *const MEDIA_TYPE_IMAGE;
extern NSString *const MEDIA_TYPE_VIDEO;
extern NSString *const MEDIA_IOS_FOLDER;
extern NSString *const ADMIN_TEXTVIEW;
extern NSString *const STORYBOARD_iPHONE;
extern NSString *const STORYBOARD_iPAD;
extern NSString *const CREDENTIALS_VIEW_ID;
extern NSString *const INITIAL_TABBAR_ID;
extern NSString *const APNS_TOKEN;
extern NSString *const SEQUENCE_NUMBER_0;
extern NSString *const ZERO_STRING;
extern NSNumber *const ZERO_NUMBER;
extern NSString *const PHONE_REGION_ES;
extern NSString *const EASTER_EGG_TEXT;
extern NSString *const EXTENSION_TYPE_PNG;
extern NSString *const EXTENSION_TYPE_MOV;
extern NSString *const TEMP_FILE_M4V;
extern int const REFRESH_MESSAGE_NUMBER;
#pragma mark -

#pragma mark Command Methods
extern NSString *const FACTORY_RESET_METHOD;
extern NSString *const UPDATE_GROUP_METHOD;
extern NSString *const UPDATE_TIMELINE_METHOD;
extern NSString *const UPDATE_MESSAGE_METHOD;
extern NSString *const UPDATE_CONTACT_METHOD;
extern NSString *const UPDATE_USER_METHOD;
extern NSString *const SEND_MESSAGE_TO_GROUP_METHOD;
extern NSString *const SEND_MESSAGE_TO_USER_METHOD;
extern NSString *const CREATE_GROUP_METHOD;
extern NSString *const DELETE_GROUP_METHOD;
extern NSString *const REMOVE_GROUP_MEMBER_METHOD;
extern NSString *const ADD_GROUP_MEMBER_METHOD;
extern NSString *const ADD_GROUP_ADMIN_METHOD;
extern NSString *const REMOVE_GROUP_ADMIN_METHOD;
extern NSString *const DELETE_TIMELINE_METHOD;
extern NSString *const CREATE_TIMELINE_METHOD;
extern NSString *const SEARCH_LOCAL_CONTACT_METHOD;
#pragma mark -

#pragma mark Entity Names.
extern NSString *const USER_ME_ENTITY;
extern NSString *const GROUP_ENTITY;
extern NSString *const TIMELINE_ENTITY;
extern NSString *const MESSAGE_ENTITY;
extern NSString *const CONTACT_ENTITY;
extern NSString *const AVATAR_ENTITY;
extern NSString *const THUMBNAIL_ENTITY;
extern NSString *const COMMAND_ENTITY;
extern NSString *const ORDERED_COMMANDS_ENTITY;
#pragma mark -

#pragma mark Notification Names.
extern NSString *const READ_COMMAND_FINISH_NOTIFICATION;
extern NSString *const SEND_COMMAND_FINISH_NOTIFICATION;
extern NSString *const TIMELINE_UPDATED_NOTIFICATION;
extern NSString *const MESSAGE_UPDATED_NOTIFICATION;
extern NSString *const AVATAR_UPDATED_NOTIFICATION;
extern NSString *const THUMBNAIL_UPDATED_NOTIFICATION;
extern NSString *const UPLOAD_UPDATED_NOTIFICATION;
extern NSString *const GROUP_UPDATED_NOTIFICATION;
extern NSString *const TIMELINE_DELETED_NOTIFICATION;
extern NSString *const USER_UPDATED_NOTIFICATION;
extern NSString *const READ_ACCOUNT_FAILED_NOTIFICATION;
extern NSString *const READ_ACCOUNT_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_ME_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_ME_FAILED_NOTIFICATION;
extern NSString *const READ_ME_AVATAR_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_ME_AVATAR_FAILED_NOTIFICATION;
extern NSString *const READ_COMMAND_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_COMMAND_FAILED_NOTIFICATION;
extern NSString *const READ_MESSAGE_AVATAR_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_MESSAGE_AVATAR_FAILED_NOTIFICATION;
extern NSString *const READ_MESSAGE_CONTENT_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_MESSAGE_CONTENT_FAILED_NOTIFICATION;
extern NSString *const READ_MESSAGE_THUMBNAIL_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_MESSAGE_THUMBNAIL_FAILED_NOTIFICATION;
extern NSString *const READ_GROUP_AVATAR_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_GROUP_AVATAR_FAILED_NOTIFICATION;
extern NSString *const CREATE_CHANNEL_SUCCESSFUL_NOTIFICATION;
extern NSString *const CREATE_CHANNEL_FAILED_NOTIFICATION;
extern NSString *const USER_AUTOREGISTER_SUCCESSFUL_NOTIFICATION;
extern NSString *const USER_AUTOREGISTER_FAILED_NOTIFICATION;
extern NSString *const DELETE_CHANNEL_SUCCESSFUL_NOTIFICATION;
extern NSString *const DELETE_CHANNEL_FAILED_NOTIFICATION;
extern NSString *const SEND_COMMAND_SUCCESSFUL_NOTIFICATION;
extern NSString *const SEND_COMMAND_FAILED_NOTIFICATION;
extern NSString *const SEND_LOG_SUCCESSFUL_NOTIFICATION;
extern NSString *const SEND_LOG_FAILED_NOTIFICATION;
extern NSString *const SEND_TRANSACTION_SUCCESSFUL_NOTIFICATION;
extern NSString *const SEND_TRANSACTION_FAILED_NOTIFICATION;
extern NSString *const READ_MESSAGE_SUCCESSFUL_NOTIFICATION;
extern NSString *const READ_MESSAGE_FAILED_NOTIFICATION;
extern NSString *const PASSWORD_RESET_REQUEST_SUCCESSFUL_NOTIFICATION;
extern NSString *const PASSWORD_RESET_REQUEST_FAILED_NOTIFICATION;
extern NSString *const PASSWORD_RESET_SUCCESSFUL_NOTIFICATION;
extern NSString *const PASSWORD_RESET_FAILED_NOTIFICATION;
#pragma mark -

#pragma mark Segue Names.
extern NSString *const TIMELINE_SEGUE;
extern NSString *const REGISTER_SEGUE;
extern NSString *const EDIT_GROUP_SEGUE;
extern NSString *const ADD_CONTACT_SEGUE;
extern NSString *const SETTINGS_SEGUE;
extern NSString *const EASTER_EGG_SEGUE;
extern NSString *const LOGOUT_SEGUE;
extern NSString *const RECOVER_PASSWORD_SEGUE;
extern NSString *const CREDENTIALS_SEGUE;
#pragma mark -

#pragma mark Cell Names.
extern NSString *const HOME_CELL;
extern NSString *const TIMELINE_TEXT_CELL;
extern NSString *const TIMELINE_MEDIA_CELL;
extern NSString *const TIMELINE_BOTTOM_CELL;
extern NSString *const ADDRESS_CELL;
extern NSString *const GROUP_MEMBER_CELL;
extern NSString *const ADD_MEMBER_CELL;
#pragma mark -

#pragma mark Image Names.
extern NSString *const IMAGE_CAMERA;
extern NSString *const IMAGE_VIDEO;
extern NSString *const IMAGE_GALLERY;
extern NSString *const IMAGE_DROP_DOWN;
extern NSString *const IMAGE_DROP_UP;
extern NSString *const IMAGE_ATTACH;
extern NSString *const IMAGE_SEND;
extern NSString *const IMAGE_ADMIN;
extern NSString *const GROUP_IMAGE;
extern NSString *const IMAGE_EDIT;
extern NSString *const IMAGE_SAVE;
extern NSString *const IMAGE_CANCEL;
extern NSString *const IMAGE_ADD_CONTACT;
extern NSString *const IMAGE_REMOVE_CONTACT;
extern NSString *const IMAGE_PERSON;
extern NSString *const IMAGE_SETTINGS_LIGHT;
extern NSString *const IMAGE_BG;
extern NSString *const IMAGE_MESSAGE_STATUS_GRAY;
extern NSString *const IMAGE_MESSAGE_STATUS_GREEN;
extern NSString *const IMAGE_KURENTO;
extern NSString *const IMAGE_CALL;
extern NSString *const IMAGE_CALL_LIGHT;
#pragma mark -

#pragma mark Thumbnail Sizes.
extern NSString *const THUMBNAIL_SIZE_SMALL;
extern NSString *const THUMBNAIL_SIZE_MEDIUM;
extern NSString *const THUMBNAIL_SIZE_LARGE;
#pragma mark -

#pragma mark User Default Keys.
extern NSString *const ACCOUNT_NAME_KEY;
extern NSString *const ACCOUNT_USER_AUTOREGISTER_KEY;
extern NSString *const ACCOUNT_GROUP_AUTOREGISTER_KEY;
extern NSString *const LASTSEQUENCE_KEY;
#pragma mark -

#pragma mark Xib File Names.
extern NSString *const DOWNLOADED_IMAGE_XIB;
extern NSString *const REGISTER_GROUP_XIB;
#pragma mark -

#pragma mark Settings Names.
extern NSString *const SETTINGS_RESOURCE;
extern NSString *const SETTINGS_TYPE;
extern NSString *const SETTINGS_PLIST;
extern NSString *const SETTINGS_PREFERENCES;
extern NSString *const SETTINGS_KEY;
extern NSString *const SETTINGS_VALUE;
extern NSString *const SETTINGS_PROTOCOL;
extern NSString *const SETTINGS_URL;
extern NSString *const SETTINGS_PORT;
extern NSString *const SETTINGS_ACCOUNT;
extern NSString *const SETTINGS_MAX_MESSAGES;
extern NSString *const SETTINGS_MAX_SPACE;
#pragma mark -

#pragma mark Lifecycle states.
extern NSString *const STATE_LOCAL;
extern NSString *const STATE_ACTIVE;
extern NSString *const STATE_DELETED;
extern NSString *const STATE_ENABLED;
extern NSString *const STATE_DISABLED;
extern NSString *const STATE_INACTIVE;
extern NSString *const STATE_NEW_MINE;
extern NSString *const STATE_NEW_OTHER;
#pragma mark -

#pragma mark Test Monitor States
extern NSString *const MSG_USR_CREATE;
extern NSString *const CMD_SEND_REQ_START;
extern NSString *const CMD_SEND_REQ_FINISH;
extern NSString *const MSG_RECV;
extern NSString *const CMD_ENQUEUE;
extern NSString *const CMD_DEQUEUE;
#pragma mark -

#pragma mark JsonRPC
extern NSString *const JSONRPC_VERSION;
extern NSString *const JSONRPC_METHOD_REGISTER;
extern NSString *const JSONRPC_CODE_OK;
extern NSString *const JSONRPC_CODE_PARSE_ERROR;
extern NSString *const JSONRPC_METHOD_SYNC;
#pragma mark -

#pragma mark 404 Codes
extern NSString *const CHANNEL_NOT_FOUND_404;
extern NSString *const SYNCHRONIZATION_IGNORE_404;
extern NSString *const SYNCHRONIZATION_ERROR_404;
#pragma mark -

#pragma mark Screen Names
extern NSString *const CREDENTIALS_VIEW;
extern NSString *const REGISTER_VIEW;
extern NSString *const PROFILE_VIEW;
extern NSString *const HOME_VIEW;
extern NSString *const ADDRESS_BOOK_VIEW;
extern NSString *const TIMELINE_VIEW;
extern NSString *const EDIT_GROUP_VIEW;
extern NSString *const ADD_GROUP_MEMBER_VIEW;
extern NSString *const SETTINGS_VIEW;
extern NSString *const EASTER_EGG_VIEW;
#pragma mark -

#pragma mark REST Services Names
extern NSString *const READ_ME_TYPE;
extern NSString *const READ_ME_AVATAR_TYPE;
extern NSString *const READ_ACCOUNT_INFO_TYPE;
extern NSString *const READ_COMMAND_TYPE;
extern NSString *const READ_MESSAGE_AVATAR_TYPE;
extern NSString *const READ_MESSAGE_CONTENT_TYPE;
extern NSString *const READ_MESSAGE_THUMBNAIL_TYPE;
extern NSString *const READ_GROUP_AVATAR_TYPE;
extern NSString *const CREATE_CHANNEL_TYPE;
extern NSString *const USER_AUTOREGISTER_TYPE;
extern NSString *const DELETE_CHANNEL_TYPE;
extern NSString *const SEND_COMMAND_TYPE;
extern NSString *const SEND_LOG_TYPE;
extern NSString *const SEND_TRANSACTION_TYPE;
extern NSString *const READ_MESSAGE_TYPE;
extern NSString *const READ_CONTACT_AVATAR_TYPE;
extern NSString *const PASSWORD_RESET_REQUEST_TYPE;
extern NSString *const PASSWORD_RESET_TYPE;
extern NSString *const UNDEFINED_TYPE;
#pragma mark -

@end
