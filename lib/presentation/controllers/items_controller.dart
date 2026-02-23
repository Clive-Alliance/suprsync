import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:suprsync/models/all_items_model.dart';
import 'package:suprsync/services/item_services.dart';

import '../../util/persistor/data_persistor.dart';
import '../dashboard_screen/auth/controller/auth_controller.dart';

class ItemsController extends GetxController {
  ItemsServices _itemsServices = ItemsServices();
  RxList<AllItemsModel> allItemsModel = <AllItemsModel>[].obs;
  AuthController _authController = Get.find();

  Future fetchAvailableLocatios() async {
    isLoading(true);
    String token = await DataPersistor.getAccessToken();

    return _itemsServices
        .fetchAllItems(token)
        .then((value) {
      // Filter the list for valid start dates

      allItemsModel(value);

      isLoading(false);

      return allItemsModel;
    });
  }

  var isLoading = false.obs;
}
