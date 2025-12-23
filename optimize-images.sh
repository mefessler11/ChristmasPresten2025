#!/bin/bash
# Bildoptimierungs-Script für das Memory-Spiel

echo "🖼️  Optimiere Bilder für bessere Performance..."

# Erstelle einen optimierten Ordner
mkdir -p images-optimized

# Prüfe ob ImageMagick installiert ist
if command -v convert &> /dev/null; then
    echo "✅ ImageMagick gefunden - Starte Optimierung..."
    
    for img in images/*.jpeg images/*.JPG images/*.jpg; do
        if [ -f "$img" ]; then
            filename=$(basename "$img")
            echo "   Optimiere $filename..."
            # Reduziere auf max 400px Breite und 85% Qualität
            convert "$img" -resize 400x400^ -quality 85 -strip "images-optimized/$filename"
        fi
    done
    
    echo "✅ Fertig! Optimierte Bilder in 'images-optimized/'"
    echo "📊 Vergleiche die Dateigrößen:"
    du -sh images/
    du -sh images-optimized/
else
    echo "❌ ImageMagick nicht installiert"
    echo "Installation mit: sudo apt-get install imagemagick"
    echo ""
    echo "Alternative: Nutzen Sie Online-Tools wie:"
    echo "  - https://tinypng.com"
    echo "  - https://squoosh.app"
    echo ""
    echo "Empfohlene Einstellungen:"
    echo "  - Max Breite/Höhe: 400px"
    echo "  - Qualität: 85%"
    echo "  - Format: JPEG"
fi
