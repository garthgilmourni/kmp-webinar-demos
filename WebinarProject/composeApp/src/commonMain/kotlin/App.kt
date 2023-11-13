import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.Button
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.navigator.CurrentScreen
import cafe.adriel.voyager.navigator.Navigator
import org.jetbrains.compose.resources.ExperimentalResourceApi
import org.jetbrains.compose.resources.painterResource

@OptIn(ExperimentalResourceApi::class)
@Composable
fun App() {
    MaterialTheme {
        Navigator(HomeScreen()) { navigator ->
            Scaffold(topBar = {
                if (navigator.canPop)
                    Button(modifier = Modifier.padding(4.dp).width(48.dp).height(48.dp), onClick = {
                        navigator.pop()
                    }) {
                        val painterResource = painterResource("back.xml")
                        Image(
                            painter = painterResource,
                            contentDescription = "Back"
                        )
                    }
            }) {
                CurrentScreen()
            }
        }
    }
}