import cafe.adriel.voyager.core.screen.Screen
import androidx.compose.runtime.*
import androidx.compose.material.Surface
import androidx.compose.ui.Modifier


data class WeatherScreen(val cityName: String, val lat: Double, val long: Double) : Screen {

    @Composable
    override fun Content() {
        Surface {
            WeatherCard(
                modifier = Modifier,
                cityName = cityName,
                lat = lat,
                long = long
            )
        }
    }
}