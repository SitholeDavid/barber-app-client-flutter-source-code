import 'package:barber_app_client/core/models/store.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service.dart';
import 'package:barber_app_client/core/services/firestore_service/firestore_service_interface.dart';
import 'package:barber_app_client/locator.dart';
import 'package:barber_app_client/ui/constants/routes.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FindShopsViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService =
      locator<FirestoreServiceInterface>();
  List<Store> stores;
  List<Store> filteredStores;

  Future initialise() async {
    setBusy(true);
    stores = await _firestoreService.getStores();
    filteredStores = List.from(stores);
    setBusy(false);
  }

  void searchForStore(String query) {
    query = query.toLowerCase();
    if (query.isEmpty)
      filteredStores = List.from(stores);
    else {
      filteredStores.clear();

      for (Store store in stores) {
        if (store.name.toLowerCase().contains(query)) {
          filteredStores.add(store);
        }
      }
    }

    notifyListeners();
  }

  void navigateToStoreDetailsView(String storeID) =>
      _navigationService.navigateTo(ShopDetailsViewRoute, arguments: storeID);
}
