/* -------------This file is hold all Packages, Path of file -------------*/

/* flutter Package */
export 'dart:async';
export 'package:flutter/material.dart';
export 'package:wallet_apps/src/service/services.dart';
export 'dart:convert';
export 'package:flutter/services.dart';
export 'dart:io' show Platform;
export 'dart:io';
export 'package:flutter/foundation.dart';
export 'package:flutter/rendering.dart';
export 'dart:typed_data';

/* Package from Pub.dev */
export 'package:connectivity/connectivity.dart';
export 'package:store_redirect/store_redirect.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:package_info/package_info.dart';
// export 'package:outline_material_icons/outline_material_icons.dart';
export 'package:pinput/pin_put/pin_put.dart';
export 'package:barcode_scan/barcode_scan.dart';
export 'package:flutter_circular_chart/flutter_circular_chart.dart';
export 'package:image_cropper/image_cropper.dart';
export 'package:autocomplete_textfield/autocomplete_textfield.dart';
export 'package:image_picker/image_picker.dart';
export 'package:qr_flutter/qr_flutter.dart';
// export 'package:firebase_remote_config/firebase_remote_config.dart';
export 'package:share/share.dart';
export 'package:flare_flutter/flare_actor.dart';
export 'package:flare_flutter/flare_controller.dart';
export 'package:http_parser/http_parser.dart';
export 'package:flutter_image_compress/flutter_image_compress.dart';
export 'package:flutter_svg/svg.dart';
export 'package:flare_flutter/flare_controls.dart';
export 'package:local_auth/local_auth.dart';
export 'package:share_extend/share_extend.dart';
export 'package:path_provider/path_provider.dart';
export 'package:sms_autofill/sms_autofill.dart';
export 'package:async/async.dart';
// export 'package:line_icons/line_icons.dart';
// export 'package:line_awesome_icons/line_awesome_icons.dart';
export 'package:line_awesome_flutter/line_awesome_flutter.dart';
export 'package:percent_indicator/percent_indicator.dart';
export 'package:pinput/pin_put/pin_put.dart';

/* Local File */
export 'package:wallet_apps/src/service/services.dart';
export 'package:wallet_apps/theme/string.dart';
export 'package:wallet_apps/src/utils/app_utils.dart';
export 'package:wallet_apps/theme/color.dart';
//export 'package:wallet_apps/src/bloc/bloc.dart';

export 'package:wallet_apps/src/config/app_config.dart';
export 'package:wallet_apps/src/config/size_config/size_config.dart';
export 'package:wallet_apps/src/route.dart';
export 'package:wallet_apps/theme/style.dart';

//Component
export 'package:wallet_apps/src/components/animation.dart';
export 'package:wallet_apps/src/components/receive_wallet_c.dart';
export 'package:wallet_apps/src/components/trx_component.dart';
export 'package:wallet_apps/src/components/platform_specific/android_native.dart';
export 'package:wallet_apps/src/components/platform_specific/ios_native.dart';
export 'package:wallet_apps/src/components/my_input.dart';
export 'package:wallet_apps/src/components/bottom_sheet.dart';
export 'package:wallet_apps/src/components/sms_component.dart';
export 'package:wallet_apps/src/components/reuse_widget.dart';
export 'package:wallet_apps/src/components/dimissible_background.dart';
export 'package:wallet_apps/src/components/route_animation.dart';

//Service
export 'package:wallet_apps/src/service/storage.dart';

/* ----------------------Route To Screen---------------------- */

// Main Screeen
export 'package:wallet_apps/src/screen/main/welcome/welcome.dart';
export 'package:wallet_apps/src/screen/main/welcome/welcome_body.dart';

// Finger Print

export 'package:wallet_apps/src/screen/main/splash_screen/splash_screen.dart';

export 'package:wallet_apps/src/screen/main/local_auth/finger_print.dart';

/* Home Screen */
export 'package:wallet_apps/src/screen/home/home.dart';
export 'package:wallet_apps/src/screen/home/home_body.dart';

export 'package:wallet_apps/src/screen/home/transaction/submit_trx/submit_trx.dart';
export 'package:wallet_apps/src/screen/home/receive_wallet/receive_wallet.dart';
export 'package:wallet_apps/src/screen/home/home.dart';
export 'package:wallet_apps/src/screen/home/home_body.dart';
export 'package:wallet_apps/src/screen/home/transaction/submit_trx/fill_pin_dialog.dart';

export 'package:wallet_apps/src/screen/home/transaction/submit_trx/submit_trx_body.dart';

export 'package:wallet_apps/src/screen/home/transaction/qr_scanner/qr_scanner.dart';

export 'package:wallet_apps/src/screen/home/receive_wallet/receive_wallet_body.dart';

/* Component File */
export 'package:wallet_apps/src/components/component.dart';
export 'package:wallet_apps/src/components/trx_option_c.dart';
export 'package:wallet_apps/src/components/home_c.dart';
export 'package:wallet_apps/src/components/menu_c.dart';
export 'package:wallet_apps/src/components/main_component.dart';

/* Menu Screen */
export 'package:wallet_apps/src/screen/home/menu/menu.dart';

export 'package:wallet_apps/src/screen/home/menu/menu_body.dart';

// Transaction Activiity
export 'package:wallet_apps/src/screen/home/menu/trx_activity/reuse_activity_widget.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity_details/transaction_activity_details.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity_body.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_activity/trx_activity_details/transaction_activity_details_body.dart';

// Transaction History
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/all_trx.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/received_trx.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/tab_bars_list/send_transaction.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history_details/trx_history_detail.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history_details/trx_history_detail_body.dart';
export 'package:wallet_apps/src/screen/home/menu/trx_history/trx_history_body.dart';

// Document

// Add Assets
export 'package:wallet_apps/src/screen/home/menu/add_asset/add_asset.dart';
export 'package:wallet_apps/src/screen/home/menu/add_asset/add_asset_body.dart';

/* ------------------- App Model ------------------*/

/* Main Screen */


export 'package:wallet_apps/src/models/model_user_info.dart';
export 'package:wallet_apps/src/models/sms_code_model.dart';
export 'package:wallet_apps/src/models/createAccountM.dart';

/* Home Screen */
export 'package:wallet_apps/src/models/portfolio_m.dart';
export 'package:wallet_apps/src/models/portfolio_rate_m.dart';

// Dashboard
export 'package:wallet_apps/src/models/model_login.dart';
export 'package:wallet_apps/src/models/home_m.dart';
export 'package:wallet_apps/src/models/model_scan_pay.dart';
export 'package:wallet_apps/src/models/createAccountM.dart';

/* Menu */
export 'package:wallet_apps/src/models/menu_m.dart';

// Change PIN
export 'package:wallet_apps/src/models/pin_m.dart';

// Change Password
export 'package:wallet_apps/src/models/password_m.dart';

// Add Asset
export 'package:wallet_apps/src/models/asset_m.dart';

// Add Phone


export 'package:wallet_apps/src/models/sms_code_model.dart';

/* ---------------------Util------------------------ */
export 'package:wallet_apps/src/utils/instance_trx_order.dart';

export 'package:responsive_framework/responsive_framework.dart';
export 'package:wallet_apps/src/models/createAccountM.dart';
export 'package:wallet_apps/src/models/fmt.dart';
export 'package:wallet_apps/src/screen/home/menu/account.dart';
export 'package:wallet_apps/src/screen/main/confirm_mnemonic.dart';
export 'package:wallet_apps/src/screen/main/contents_backup.dart';
export 'package:wallet_apps/src/screen/main/import_account/import_acc.dart';
export 'package:wallet_apps/src/screen/main/import_user_info/import_user_infor.dart';
