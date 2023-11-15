package com.kmp.webinar

import androidx.compose.foundation.background
import androidx.compose.runtime.*
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import cafe.adriel.voyager.navigator.LocalNavigator
import cafe.adriel.voyager.navigator.currentOrThrow
import country.CapitalInfo

@Composable
fun WeatherButton(modifier: Modifier = Modifier, capitals: List<String>, capitalInfo: CapitalInfo) {
    val navigator = LocalNavigator.currentOrThrow
    Row(
        modifier = modifier,
        verticalAlignment = Alignment.Bottom
    ) {
        Column {
            capitals.forEach {
                Button(
                    shape = RoundedCornerShape(20.dp),
                    colors = ButtonDefaults.outlinedButtonColors(
                        contentColor = Color.Black
                    ),
                    onClick = {
                        navigator.push(
                            WeatherScreen(
                                cityName = it,
                                lat = capitalInfo.latlng[0].toDouble(),
                                long = capitalInfo.latlng[1].toDouble()
                            )
                        )
                }) {
                    Text(text = "$it weather")
                }
            }
        }
    }
}