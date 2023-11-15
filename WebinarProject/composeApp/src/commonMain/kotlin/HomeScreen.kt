import cafe.adriel.voyager.core.screen.Screen
import androidx.compose.material.Surface
import androidx.compose.runtime.*
import country.Country
import location.getCountryCode
import cache.CountrySDK
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.material.Text
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.ui.Alignment.Companion.CenterHorizontally
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.compose.material.MaterialTheme

class HomeScreen() : Screen {
    @Composable
    override fun Content() {
        Surface {
            var listCountries: MutableList<Country> by remember { mutableStateOf(mutableListOf()) }

            val countryCode = getCountryCode().getCountryCode()

            LaunchedEffect(Unit) {
                val tempCountries =
                    CountrySDK().getLaunches().sortedBy { it.name.common }.toMutableList()
                val currentCountry = tempCountries.first { it.cca2 == countryCode }
                tempCountries.remove(currentCountry)
                tempCountries.add(0, currentCountry)
                listCountries = tempCountries
            }

            Column {
                LazyColumn() {
                    items(items = listCountries) {
                        CountryCard(
                            modifier = Modifier,
                            country = it,
                            currentCountry = it.cca2 == countryCode
                        )
                    }
                }
            }
        }
    }
}
