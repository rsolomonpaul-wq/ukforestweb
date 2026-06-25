const popupContainer = document.createElement("div");
popupContainer.id = "infodiv";
popupContainer.style.cssText = `
    position:absolute;
    background:white;
    border-radius:10px;
    border:1px solid #ccc;
    min-width:300px;
    max-height:330px;
    overflow:hidden;
    box-shadow:0 4px 12px rgba(0,0,0,0.25);
    font-size:13px;
    z-index:9999;
`;

// 🔥 HEADER (SEPARATE)
const popupHeader = document.createElement("div");
popupHeader.className = "header";
popupHeader.style.cssText = `
    background:#2e7d32;
    color:white;
    padding:8px 10px;
    font-weight:bold;
    display:flex;
    justify-content:space-between;
    align-items:center;
`;

const title = document.createElement("span");
title.innerHTML = "🌱 Plantation Details";

const closeBtn = document.createElement("button");
closeBtn.innerHTML = "✖";
closeBtn.type = "button";
closeBtn.style.cssText = `
    border:none;
    background:transparent;
    color:white;
    cursor:pointer;
    font-size:14px;
`;

popupHeader.appendChild(title);
popupHeader.appendChild(closeBtn);

// 🔥 CONTENT
const popupContent = document.createElement("div");
popupContent.style.cssText = `
    padding:10px;
    max-height:340px;
    overflow-y:auto;
`;

// Append
popupContainer.appendChild(popupHeader);
popupContainer.appendChild(popupContent);


// ==================== OVERLAY ====================
const overlay = new ol.Overlay({
    element: popupContainer,
    positioning: "bottom-center",
    stopEvent: true,
    offset: [0, -10]
});

map.addOverlay(overlay);

// Close popup
closeBtn.onclick = function () {
    overlay.setPosition(undefined);
};

// ==================== CLICK EVENT ====================
// Function to format keys
function formatLabel(key) {
    return key
        .replace(/_/g, " ")                  // replace _ with space
        .replace(/\w\S*/g, txt =>           // capitalize each word
            txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()
        );
}


map.on("singleclick", function (evt) {

    const feature = map.forEachFeatureAtPixel(evt.pixel, function (f) {
        return f;
    });

    if (!feature) {
        overlay.setPosition(undefined);
        return;
    }

    const plantationCode = feature.get("plantation_code");

    const plantationData = data.find(x =>
        x?.plantation?.plantation_code == plantationCode
    );

    if (!plantationData) {

        popupContent.innerHTML = `
            <div style="
                padding:15px;
                color:red;
                font-weight:bold;">
                Plantation data not found.
            </div>
        `;

        overlay.setPosition(evt.coordinate);
        return;
    }

    let html = "";

    function formatFieldValue(value) {

        if (
            value === null ||
            value === undefined ||
            value === ""
        ) {
            return "NA";
        }

        if (typeof value === "string") {

            const lowerValue = value.toLowerCase();

            // Images
            if (
                lowerValue.includes(".jpg") ||
                lowerValue.includes(".jpeg") ||
                lowerValue.includes(".png") ||
                lowerValue.includes(".webp")
            ) {

                return `
                    <a href="${value}"
                       target="_blank"
                       style="
                            color:#198754;
                            font-weight:600;">
                        View Image
                    </a>
                `;
            }

            // Documents
            if (
                lowerValue.includes(".pdf") ||
                lowerValue.includes(".doc") ||
                lowerValue.includes(".docx") ||
                lowerValue.includes(".xls") ||
                lowerValue.includes(".xlsx") ||
                lowerValue.includes(".zip") ||
                lowerValue.includes(".kml")
            ) {

                return `
                    <a href="${value}"
                       target="_blank"
                       style="
                            color:#0d6efd;
                            font-weight:600;">
                        View
                    </a>
                `;
            }

            // Generic URL
            if (
                value.startsWith("http://") ||
                value.startsWith("https://")
            ) {

                return `
                    <a href="${value}"
                       target="_blank"
                       style="
                            color:#0d6efd;
                            font-weight:600;">
                        View
                    </a>
                `;
            }
        }

        return value;
    }

    function renderSection(title, sectionData) {

        if (!sectionData)
            return "";

        let sectionHtml = `
            <div style="margin-top:10px;">

                <div style="
                    background:#2e7d32;
                    color:white;
                    padding:8px;
                    border-radius:4px;
                    font-weight:bold;">
                    ${title}
                </div>
        `;

        // ARRAY SECTION
        if (Array.isArray(sectionData)) {

            if (sectionData.length === 0) {

                sectionHtml += `
                    <div style="
                        padding:8px;
                        border:1px solid #ddd;
                        background:#fafafa;">
                        No Records Found
                    </div>
                `;

                sectionHtml += `</div>`;
                return sectionHtml;
            }

            sectionData.forEach(function (row, index) {

                sectionHtml += `
                    <div style="
                        background:#f5f5f5;
                        padding:6px;
                        margin-top:8px;
                        font-weight:bold;">
                        Record ${index + 1}
                    </div>

                    <table style="
                        width:100%;
                        border-collapse:collapse;">
                `;

                Object.keys(row).forEach(function (key) {

                    let value = formatFieldValue(row[key]);

                    sectionHtml += `
                        <tr>
                            <td style="
                                border:1px solid #ddd;
                                padding:5px;
                                font-weight:bold;
                                width:40%;
                                background:#fafafa;">
                                ${formatLabel(key)}
                            </td>

                            <td style="
                                border:1px solid #ddd;
                                padding:5px;">
                                ${value}
                            </td>
                        </tr>
                    `;
                });

                sectionHtml += `</table>`;
            });
        }

        // OBJECT SECTION
        else {

            sectionHtml += `
                <table style="
                    width:100%;
                    border-collapse:collapse;
                    margin-top:5px;">
            `;

            Object.keys(sectionData).forEach(function (key) {

                if (key.toLowerCase() === "geojson")
                    return;

                let value = formatFieldValue(sectionData[key]);

                sectionHtml += `
                    <tr>
                        <td style="
                            border:1px solid #ddd;
                            padding:5px;
                            font-weight:bold;
                            width:40%;
                            background:#fafafa;">
                            ${formatLabel(key)}
                        </td>

                        <td style="
                            border:1px solid #ddd;
                            padding:5px;">
                            ${value}
                        </td>
                    </tr>
                `;
            });

            sectionHtml += `</table>`;
        }

        sectionHtml += `</div>`;

        return sectionHtml;
    }

    // Plantation Information
    html += renderSection(
        "Plantation Information",
        plantationData.plantation
    );

    // Section 1 to Section 7
    for (let i = 1; i <= 7; i++) {

        html += renderSection(
            "Section " + i,
            plantationData["section_" + i]
        );
    }

    popupContent.innerHTML = html;

    overlay.setPosition(evt.coordinate);
});