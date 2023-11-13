import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.material.Card
import androidx.compose.foundation.Image
import androidx.compose.material.MaterialTheme
import androidx.compose.ui.unit.dp
import com.seiko.imageloader.rememberImagePainter
import androidx.compose.ui.layout.ContentScale
import country.Flags

@Composable
fun Flag(modifier: Modifier = Modifier, flag: Flags) {
    Card(
        modifier = modifier,
        elevation = 10.dp,
        shape = MaterialTheme.shapes.small
    ) {
        val painterResource = rememberImagePainter(flag.png)
        Image(
            painter = painterResource,
            contentDescription = flag.alt,
            contentScale = ContentScale.FillBounds
        )
    }
}