// LIBRARIAN STATISTICS - Interactive Logic System

document.addEventListener('DOMContentLoaded', () => {
    // 1. Data Store
    const populationData = {
        '서울': 9331828, '부산': 3266598, '대구': 2363629, '인천': 3021010,
        '광주': 1408422, '대전': 1439157, '울산': 1098049, '세종': 390685,
        '경기': 13694685, '강원': 1517766, '충북': 1591177, '충남': 2136574,
        '전북': 1738690, '전남': 1788819, '경북': 2531384, '경남': 3228380,
        '제주': 670368
    };

    const currentLibrarians = {
        '서울': 2085, '부산': 559, '대구': 372, '인천': 432,
        '광주': 195, '대전': 181, '울산': 143, '세종': 97,
        '경기': 2168, '강원': 265, '충북': 233, '충남': 300,
        '전북': 297, '전남': 311, '경북': 372, '경남': 617,
        '제주': 141
    };

    const regionContext = {
        '세종': "세종시는 10년 전 직원 23명, 사서 9명 수준에서 현재 사서 97명으로 증가하여 사서 수가 977.8% 폭증하였습니다. 현재 사서 확보율 전국 1위(64.24%)로 행정수도 건설 정책에 따른 정밀 서비스 인프라를 잘 확보하고 있습니다.",
        '서울': "서울시는 사서 확보율이 최고 수준(62.51%)에 이르며, 방문객 대비 대출 권수는 비교적 하위권에 해당합니다. 이는 서울의 도서관들이 단순 대출 목적을 넘어 정보 학습, 전시, 세미나 등 복합문화 공간 소비 형태로 활성화되었음을 시사합니다.",
        '부산': "부산시는 사서 확보율 60.69%로 전국 3위를 기록하고 있으며, 방문객 1인당 연간 대출 수가 0.75권으로 활성화도가 매우 높습니다. 균형 있는 인력 배치와 도서 이용 문화가 잘 융합된 모범 지자체입니다.",
        '대구': "대구시는 사서 확보율 60.24%로 인프라가 든든하게 받쳐주고 있으며, 방문자 1인당 대출 수는 0.80권으로 특광역시 중 대출 활성화율이 최상위급에 위치한 활동적 성격의 도서관 문화를 가집니다.",
        '경남': "경상남도는 도 단위 지자체 중 사서 확보율 1위(46.53%)에 해당하며, 지난 10년간 전체 직원 수 증가(+37.3%)보다 사서 충원율(+65.4%)을 높게 가져가는 긍정적이고 구조적인 발전을 이루어 왔습니다.",
        '강원': "강원도는 확보율 37.19%로 하위권에 머물고 있습니다. 사서율 부족은 현장의 맞춤형 문화 프로그램 기획력과 이용자 상호작용 저하로 이어져, 방문자당 대출 수 0.50권(최하위권)이라는 활성화 격차를 낳았습니다.",
        '광주': "광주광역시는 지자체 중 확보율 14위(35.55%)로 정체된 상태입니다. 인구 대비 전문 사서 풀의 밀도가 낮아 향후 질적 행정 서비스를 위해서는 단계적인 전문 인력 채용 증대가 필요합니다.",
        '충북': "충청북도는 사서 확보율이 35.04%로 최하위권에 그쳤으며, 연간 예산 중 자료구입비 비중(6.2%) 또한 전국 하위권에 속해 있어, 도서관 인력과 콘텐츠 확충에 대한 신규 투자가 시급한 실정입니다.",
        '전북': "전라북도는 확보율 34.82%로 전남과 더불어 심각한 인력 정체를 보여줍니다. 사서 1인당 예산 행정 부담이 커 소수 인원이 과도한 일반 행정에 치우치는 병목 현상이 발생하고 있습니다.",
        '전남': "전라남도는 전국 최하위 사서 확보율(32.88%)을 기록하고 있습니다. 10년간 사서 수급이 정체된 반면, 77개나 되는 광활한 도서관 장서(1인당 2.2만권) 관리 부담이 소수 사서에게 기형적으로 과적된 행정 정체 현상이 심각합니다."
    };

    const galleryCaptions = {
        'national': '<strong>전국 사서 확보율 및 관당 인력 변화 (2015-2024)</strong><br>도서관 인프라의 증대와 함께 전체 사서 자격증 보유자도 꾸준히 증가하여, 관당 배치 사서 수는 5.5명에서 6.8명으로 증가했습니다.',
        'region-2024': '<strong>2024년 17개 시도별 사서 확보율 및 양극화 실태</strong><br>세종(64.2%), 서울(62.5%) 등 대도시는 확보율이 60%를 상회하지만, 전남(32.8%), 전북(34.8%) 등 도 단위 지역은 30%대 초중반에 정체되어 양극화가 뚜렷합니다.',
        'region-change': '<strong>최근 10년간(2015-2024) 시도별 사서 확보율 증감폭</strong><br>세종시(+25.11%p)와 제주(+13.21%p)가 도서관 인력 확충에 가장 크게 기여한 반면, 경상북도(-0.86%p)는 전국에서 유일하게 사서 비중이 감소했습니다.',
        'workload': '<strong>2024년 시도별 사서 1인당 장서 관리 부담 vs 대출 업무량 상관도</strong><br>사서 1인이 감당하는 업무 로드를 보여줍니다. 대전, 세종은 대민 대출 부하가, 전남과 충남은 장서 관리 중심의 물리적 관리가 가중되어 있습니다.',
        'global': '<strong>공공도서관 1관당 담당 인구 및 인프라 수준 국제 비교</strong><br>대한민국은 도서관 1관당 약 3.9만 명의 인구를 담당하고 있어 미국(3.6만 명), 일본(3.7만 명), 독일(1.2만 명) 등 OECD 국가에 비해 물리적 서비스 접근 인프라가 협소합니다.'
    };

    // 2. Tab Menu switching for Gallery
    const tabButtons = document.querySelectorAll('.tab-btn');
    const galleryImg = document.getElementById('gallery-image');
    const galleryCap = document.getElementById('gallery-caption');

    tabButtons.forEach(button => {
        button.addEventListener('click', (e) => {
            // Remove active from all tabs
            tabButtons.forEach(btn => btn.classList.remove('active'));
            // Add active to current
            button.classList.add('active');

            const target = button.getAttribute('data-target');
            let imgName = '';

            switch (target) {
                case 'national':
                    imgName = 'national_trend.png';
                    break;
                case 'region-2024':
                    imgName = 'region_comparison_2024.png';
                    break;
                case 'region-change':
                    imgName = 'region_change_10yr.png';
                    break;
                case 'workload':
                    imgName = 'workload_analysis.png';
                    break;
                case 'global':
                    imgName = 'international_comparison.png';
                    break;
            }

            // Update Image with transition fade-out/fade-in
            galleryImg.style.opacity = 0;
            setTimeout(() => {
                galleryImg.src = 'images/' + imgName;
                galleryCap.innerHTML = galleryCaptions[target];
                galleryImg.style.opacity = 1;
            }, 200);
        });
    });

    // 3. Cabinet Drawers (Accordions)
    const drawers = document.querySelectorAll('.cabinet-drawer');
    drawers.forEach(drawer => {
        drawer.addEventListener('click', () => {
            // Check if already active
            const isActive = drawer.classList.contains('active');
            
            // Close all first
            drawers.forEach(d => d.classList.remove('active'));
            
            // Toggle active state
            if (!isActive) {
                drawer.classList.add('active');
            }
        });
    });

    // 4. Global Staffing Calculator
    const calcRegionSelect = document.getElementById('calc-region');
    const calcStandardSelect = document.getElementById('calc-standard');
    
    const resRegionName = document.getElementById('res-region-name');
    const resCurrentLibrarians = document.getElementById('res-current-librarians');
    const resTargetLibrarians = document.getElementById('res-target-librarians');
    
    const barCurrent = document.getElementById('bar-current');
    const barTarget = document.getElementById('bar-target');
    const resAdviceText = document.getElementById('res-advice-text');

    function calculateStaffing() {
        const region = calcRegionSelect.value;
        const standard = calcStandardSelect.value;
        
        const population = populationData[region];
        const current = currentLibrarians[region];
        
        let targetRatio = 4000; // default (kr-law)
        let standardName = '한국 현행법';
        
        if (standard === 'us') {
            targetRatio = 3800;
            standardName = '미국 표준';
        } else if (standard === 'jp') {
            targetRatio = 4500;
            standardName = '일본 표준';
        } else if (standard === 'eu') {
            targetRatio = 2000;
            standardName = '유럽 복지 표준';
        } else if (standard === 'kr-law') {
            targetRatio = 4000;
            standardName = '대한민국 법정 기준';
        }

        const target = Math.ceil(population / targetRatio);
        const additional = Math.max(0, target - current);

        // Update Text
        resRegionName.textContent = region + (region.endsWith('도') || region.endsWith('시') ? '' : '특별자치시/광역시/도');
        resCurrentLibrarians.textContent = current.toLocaleString() + '명';
        resTargetLibrarians.textContent = target.toLocaleString() + '명';

        // Update Charts (Relative percentages)
        const maxVal = Math.max(current, target);
        const currentPct = (current / maxVal) * 100;
        const targetPct = (target / maxVal) * 100;

        barCurrent.style.width = currentPct + '%';
        barCurrent.textContent = `현재 (${current.toLocaleString()}명)`;
        
        barTarget.style.width = targetPct + '%';
        barTarget.textContent = `권장 (${target.toLocaleString()}명)`;

        // Update Advice Text
        if (additional > 0) {
            resAdviceText.innerHTML = `<strong>${region}</strong>(인구 ${population.toLocaleString()}명)은 <strong>${standardName}</strong> 기준(사서 1인당 ${targetRatio.toLocaleString()}명 케어)을 달성하기 위해 **약 ${additional.toLocaleString()}명**의 전문 사서 인력이 추가로 충원되어야 합니다.`;
            resAdviceText.style.borderLeftColor = 'var(--color-brand-secondary)';
        } else {
            resAdviceText.innerHTML = `<strong>${region}</strong>(인구 ${population.toLocaleString()}명)은 현재 사서 ${current.toLocaleString()}명을 보유하여, <strong>${standardName}</strong> 기준(권장 사서 수 ${target.toLocaleString()}명)을 충족하고 있는 인력 여건 지자체입니다.`;
            resAdviceText.style.borderLeftColor = 'var(--color-success-text)';
        }
    }

    calcRegionSelect.addEventListener('change', calculateStaffing);
    calcStandardSelect.addEventListener('change', calculateStaffing);
    // Initial run
    calculateStaffing();

    // 5. Table Row Hover Event
    const tableRows = document.querySelectorAll('#staff-table tbody tr[data-region]');
    const hoverCardText = document.getElementById('hover-card-text');

    tableRows.forEach(row => {
        row.addEventListener('mouseenter', () => {
            const region = row.getAttribute('data-region');
            const context = regionContext[region] || `${region} 지역의 도서관 통계 데이터입니다. 세부 행정 특이사항은 전체 리포트에서 확인해 주세요.`;
            
            hoverCardText.style.opacity = 0;
            setTimeout(() => {
                hoverCardText.innerHTML = `<strong>${region} 행정 분석:</strong><br>${context}`;
                hoverCardText.style.opacity = 1;
            }, 100);
        });
    });

    // 6. Lightbox for Gallery Image zoom
    const lightboxModal = document.createElement('div');
    lightboxModal.className = 'lightbox-modal';
    lightboxModal.innerHTML = `<img class="lightbox-content" src="" alt="확대 보기">`;
    document.body.appendChild(lightboxModal);

    const lightboxImg = lightboxModal.querySelector('.lightbox-content');
    
    galleryImg.parentElement.addEventListener('click', () => {
        lightboxImg.src = galleryImg.src;
        lightboxModal.classList.add('active');
    });

    lightboxModal.addEventListener('click', () => {
        lightboxModal.classList.remove('active');
    });
});
