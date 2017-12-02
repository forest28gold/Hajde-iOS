//
//  Global.h
//
//  Created by AppsCreationTech on 03/12/16.
//  Copyright (c) 2016 AppsCreationTech. All rights reserved.
//

#ifndef HAJDE_Global_h
#define HAJDE_Global_h

//#define BACKEND_APP_ID                                              @"139E089A-02CE-4977-FF83-86A71B6DAF00"   //Hajde
//#define BACKEND_SECRET_KEY                                          @"B1EF31DE-8AE0-4B50-FF70-CAA0F503B100"
//#define BACKEND_VERSION_NUM                                         @"v1"

#define BACKEND_APP_ID                                              @"369D443F-F691-EFF0-FF55-FB7F66E34900"
#define BACKEND_SECRET_KEY                                          @"8EEF0234-6F97-271F-FF86-B9A149C05800"
#define BACKEND_VERSION_NUM                                         @"v1"

#define HAJDE_FACEBOOK_LINK                                         @"https://www.facebook.com/hajdeapp"
#define HAJDE_TWITTER_LINK                                          @"https://twitter.com/Hajdeapp"
#define HAJDE_GOOGLE_LINK                                           @"https://plus.google.com/u/0/115676550960064541720"
#define HAJDE_APP_LINK                                              @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1113329989"
//AIzaSyAs6ZP-kK40e_-elyrnTErnSlmNR4W9IQE
#define REVERSE_GEO_CODING_URL                                      @"https://maps.googleapis.com/maps/api/geocode/json?"

#define TABBAR_HEIGHT                                               50
#define BACK_IMAGE_SIZE                                             CGSizeMake(640, 250)
#define LOAD_DATA_COUNT                                             50
#define PHOTO_HEIGHT                                                180
#define POST_IMAGE_SIZE                                             CGSizeMake(2016, 3580)

#define VIEW_GET_STARTED                                            @"HDGetStartedViewController"
#define VIEW_PRIVACY_POLICY                                         @"HDPrivacyPolicyViewController"
#define VIEW_TAB                                                    @"HDTabBarViewController"
#define VIEW_TAB_HOME                                               @"HDTabHomeViewController"
#define VIEW_TAB_PROFILE                                            @"HDTabProfileViewController"
#define VIEW_TAB_ADD                                                @"HDTabAddViewController"
#define VIEW_TAB_SHOP                                               @"HDTabShopViewController"
#define VIEW_TAB_MORE                                               @"HDTabMoreViewController"

#define VIEW_NEWEST_POSTS                                           @"HDNewestPostsViewController"
#define VIEW_MOST_COMMENTED                                         @"HDMostCommentedViewController"
#define VIEW_MOST_VOTES                                             @"HDMostVotesViewController"

#define VIEW_MY_NEWEST_POSTS                                        @"HDMyNewestPostsViewController"
#define VIEW_MY_MOST_COMMENTED                                      @"HDMyMostCommentedViewController"
#define VIEW_MY_MOST_VOTES                                          @"HDMyMostVotesViewController"

#define VIEW_POST_DETAILS                                           @"HDPostDetailsViewController"
#define VIEW_PHOTO_DETAILS                                          @"HDPhotoDetailsViewController"

#define VIEW_NEW_IMAGE                                              @"HDNewImageViewController"
#define VIEW_IMAGE_EDIT                                             @"HDImageEditViewController"
#define VIEW_NEW_POST                                               @"HDNewPostViewController"
#define VIEW_NEW_VOICE                                              @"HDNewVoiceViewController"
#define VIEW_PREVIEW_RECORDING                                      @"HDPreviewRecordingViewController"

#define VIEW_OFFERS                                                 @"HDOffersViewController"
#define VIEW_OFFER_DETAILS                                          @"HDOfferDetailsViewController"

#define VIEW_MY_POSTS                                               @"HDMyPostsViewController"
#define VIEW_MY_COMMENTS                                            @"HDMyCommentsViewController"
#define VIEW_MY_VOTES                                               @"HDMyVotesViewController"
#define VIEW_MY_KARMA                                               @"HDMyKarmaViewController"

#define VIEW_HAJDE_FEEDBACK                                         @"HDHajdeFeedbackViewController"
#define VIEW_WHAT_KARMA                                             @"HDWhatKarmaViewController"
#define VIEW_TERMS_USE                                              @"HDTermsOfUseViewController"
#define VIEW_INVITE_FRIENDS                                         @"HDInviteFriendsViewController"

#define SEGUE_NEW_IMAGE                                             @"segue_new_image"
#define SEGUE_IMAGE_EDIT                                            @"segue_image_edit"
#define SEGUE_NEW_POST                                              @"segue_new_post"
#define SEGUE_NEW_VOICE                                             @"segue_new_voice"

#define SEGUE_FEEDBACK                                              @"segue_feedback"
#define SEGUE_WHATS_KARMA                                           @"segue_whats_karma"
#define SEGUE_TERMS_USE                                             @"segue_terms_use"

#define SEGUE_OFFERS                                                @"segue_offers"
#define SEGUE_OFFER_DETAILS                                         @"segue_offer_details"
#define SEGUE_INVITE_FRIENDS                                        @"segue_invite_friends"

#define SEGUE_PHOTO                                                 @"segue_photo"

#define UNWIND_POST_PHOTO                                           @"unWindPostPhoto"
#define UNWIND_POST_VOICE                                           @"unWindPostVoice"
#define UNWIND_GOTO_OFFER_KARMA                                     @"unWindGoToOfferKarma"
#define UNWIND_GOTO_OFFER                                           @"unWindGoToOffer"

#define COLOR_1                                                     @"36d7b7"  //green
#define COLOR_2                                                     @"fece4c"  //yellow
#define COLOR_3                                                     @"aab2bd"  //grey
#define COLOR_4                                                     @"fe4c4c"  //red
#define COLOR_5                                                     @"6686ff"  //orion
#define COLOR_6                                                     @"ff78d4"  //pink
#define COLOR_7                                                     @"fe824c"  //yellowish
#define COLOR_8                                                     @"50e0f5"  //verdant green
#define COLOR_9                                                     @"9878ff"  //fuchsia
#define COLOR_10                                                    @"43b9f6"  //blue
#define COLOR_11                                                    @"43f6d6"  //absinthe

#define COMMENT_COLOR_1                                             @"6de1ca"
#define COMMENT_COLOR_2                                             @"f8d882"
#define COMMENT_COLOR_3                                             @"c2cad6"
#define COMMENT_COLOR_4                                             @"ed7d7d"
#define COMMENT_COLOR_5                                             @"849eff"
#define COMMENT_COLOR_6                                             @"fe99de"
#define COMMENT_COLOR_7                                             @"fe9669"
#define COMMENT_COLOR_8                                             @"7decfc"
#define COMMENT_COLOR_9                                             @"ac92ff"
#define COMMENT_COLOR_10                                            @"6cccff"
#define COMMENT_COLOR_11                                            @"78f6df"

#define RECORD_FILE_FORMAT                                          @"m4a"

#define USER_SIGNUP                                                 @"signup"
#define USER_LOGIN                                                  @"login"
#define USER_BEGIN                                                  @"begin"

#define POST_TYPE_PHOTO                                             @"photo"
#define POST_TYPE_TEXT                                              @"text"
#define POST_TYPE_AUDIO                                             @"audio"

#define COMMENT_TYPE_ME                                             @"mycomment"
#define LIKE_TYPE                                                   @"like"
#define DISLIKE_TYPE                                                @"dislike"

#define KARMA_SCORE_LOGIN                                           20
#define KARMA_SCORE_POST                                            10
#define KARMA_SCORE_COMMENT                                         10
#define KARMA_SCORE_VOTE_LIKE                                       5
#define KARMA_SCORE_VOTE_DISLIKE                                    5
#define KARMA_SCORE_ABUSE                                           5
#define KARMA_SCORE_DECREASE_POST                                   -5
#define KARMA_SCORE_DELETE_POST                                     -20

#define KARMA_LOGIN                                                 @"karma_login"
#define KARMA_POST                                                  @"karma_post"
#define KARMA_COMMENT                                               @"karma_comment"
#define KARMA_VOTE_LIKE                                             @"karma_vote_like"
#define KARMA_VOTE_DISLIKE                                          @"karma_vote_dislike"
#define KARMA_ABUSE                                                 @"karma_abuse"
#define KARMA_COMMENT_LIKE                                          @"karma_comment_like"
#define KARMA_COMMENT_DISLIKE                                       @"karma_comment_dislike"
#define KARMA_COMMENT_ABUSE                                         @"karma_comment_abuse"
#define KARMA_DECREASE_POST                                         @"karma_decrease_post"
#define KARMA_DECREASE_COMMENT                                      @"karma_decrease_comment"
#define KARMA_DECREASE_DELETE_POST                                  @"karma_decrease_delete_post"
#define KARMA_DECREASE_DELETE_COMMENT                               @"karma_decrease_delete_comment"
#define KARMA_REPORT_DELETE_POST                                    @"karma_report_delete_post"
#define KARMA_REPORT_DELETE_COMMENT                                 @"karma_report_delete_comment"

#define SELECT_NEWEST                                               @"select_newest"
#define SELECT_MOST_COMMENTED                                       @"select_most_commented"
#define SELECT_MOST_VOTES                                           @"select_most_votes"
#define SELECT_MY_POSTS                                             @"select_my_posts"
#define SELECT_MY_VOTES                                             @"select_my_votes"

#define MESSAGING_CHANNEL                                           @"default"
#define HAJDE_PASSWORD                                              @"2D498E77-5D46-4205-BCCC-2558D2EDCA0D"

#define NEARBY_RADIUS                                               20
#define ADMIN_EMAIL                                                 @"hajde@hajde.com"

#define PUSH_BADGE                                                  @"1"
#define PUSH_SOUND                                                  @"chime"

#define LANG_ENG                                                    @"English"
#define LANG_ALB                                                    @"Albanian"

#define COUNTRY_ALBANIA                                             @"Albania"
#define COUNTRY_BOSNIA_HEREZE                                       @"Bosnia and Herzegovina"
#define COUNTRY_KOSOVO                                              @"Kosovo"
#define COUNTRY_MACEDONIA                                           @"Macedonia (FYROM)"
#define COUNTRY_MONTENEGRO                                          @"Montenegro"
#define COUNTRY_SERBIA                                              @"Serbia"
#define COUNTRY_SWISS                                               @"Switzerland"
#define COUNTRY_TURKEY                                              @"Turkey"
#define COUNTRY_OTHERS                                              @"Others"

#define CURRENCY_ALBANIA                                            @"Lek"
#define CURRENCY_BOSNIA_HEREZE                                      @"KM"
#define CURRENCY_KOSOVO                                             @"€"
#define CURRENCY_MACEDONIA                                          @"MKD"
#define CURRENCY_MONTENEGRO                                         @"€"
#define CURRENCY_SERBIA                                             @"DIN"
#define CURRENCY_SWISS                                              @"CHF"
#define CURRENCY_TURKEY                                             @"TL"
#define CURRENCY_OTHERS                                             @"$"

#define SUPPORT_EMAIL                                               @"support@hajdeapp.com"

// show SVProgressHUD

#define SVPROGRESSHUD_SHOW                                          [SVProgressHUD showWithStatus:NSLocalizedString(@"please_wait", "") maskType:SVProgressHUDMaskTypeClear]
#define SVPROGRESSHUD_DISMISS                                       [SVProgressHUD dismiss]
#define SVPROGRESSHUD_SUCCESS(status)                               [SVProgressHUD showSuccessWithStatus:status]
#define SVPROGRESSHUD_ERROR(status)                                 [SVProgressHUD showErrorWithStatus:status]
#define SVPROGRESSHUD_NETWORK_ERROR                                 [SVProgressHUD showErrorWithStatus:NETWORK_ERR_MESSAGE]

// Backendless Key

#define BACKEND_URL_IMAGE                                           @"imgBackgorund"
#define BACKEND_URL_AUDIO                                           @"audio"
#define BACKEND_URL_OFFER                                           @"offerImages"

#define KEY_OBJECT_ID                                               @"objectId"
#define KEY_DEVICE_UUID                                             @"deviceUUID"
#define KEY_PASSWORD                                                @"password"
#define KEY_SPENT_TIME                                              @"spentTime"
#define KEY_KARMA_SCORE                                             @"karmaScore"
#define KEY_POST_COUNT                                              @"postCount"
#define KEY_COMMENT_COUNT                                           @"commentCount"
#define KEY_VOTE_COUNT                                              @"voteCount"
#define KEY_LAST_LOGIN                                              @"lastLogin"

#define KEY_USER_ID                                                 @"userID"
#define KEY_TYPE                                                    @"type"
#define KEY_LATITUDE                                                @"latitude"
#define KEY_LONGITUDE                                               @"longitude"
#define KEY_POST_ID                                                 @"postID"
#define KEY_LIKE_TYPE                                               @"likeType"
#define KEY_COMMENT_TYPE                                            @"commentType"

#define KEY_SHOP_ID                                                 @"shopID"


#endif
