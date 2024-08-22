## 시계열분석 오답노트

### ==ARIMA에 대한 주요 결과 해석==

- ARIMA 분석은 총 3단계를 통해 수행

#### 1. 모형의 각 항이 유의한지 여부 확인

- 항에 대한 p값을 유의수준과 비교하여 귀무가설 평가
- 귀무가설: 계수들이 0과 같은 값을 가지며, 독립적이다.
- 만약 p값이 유의수준 (0.05)보다 작으면 귀무가설을 기각하여 독립적이지 않고 자기상관성이 존재함을 의미

#### 2. 모형이 데이터를 얼마나 잘 적합시키는지 확인

- 평균제곱오차 (MS)를 통해 모형의 적합도 확인 가능 (MS의 값이 작을 수록 더 적합한 모형임을 나타냄)
- ![image-20240405221139779](./imgs/image-20240405221139779.png)

#### 3. 모형이 분석의 가정을 충족하는지 여부 확인

- Ljung-Box 카이-제곱 통계량 및 잔차의 자기상관함수를 사용하면 모형이 잔차가 서로 독립적이라는 각정을 충족하는지 여부를 확인할 수 있음.
- 가정이 충족되지 않으면 모형이 데이터에 적합하지 않음.
- ![image-20240405221354778](./imgs/image-20240405221354778.png)
- 위 결과에서 Ljug-Box 카이-제곱 통계량에 대한 p값은 모두 0.05보다 크고, 잔차의 자기상관함수에 대한 어느 상관도 유의하지 않음. 모형이 잔차가 서로 독립적이라는 가정을 충족한다는 결론을 내릴 수 있음.
- 잔차가 독립적이라는 것은 white noise를 따른다고 해석할 수 있음.

---

### ==ARMA 모형의 이론적 ACF와 PACF의 패턴==

- |           | ACF                       | PACF                      |
  | --------- | ------------------------- | ------------------------- |
  | AR(p)     | **tails off**             | cut off at lag p          |
  | MA(q)     | cut off at lag q          | **tails off**             |
  | ARMA(p,q) | tails off after lag (q-p) | tails off after lag (p-q) |

---

### ==Yule-Walker equation==

- Yule-Walker 방정식을 통해 모수를 추정할 수 있으며, ACF와 AR모델을 연결할 수 있음.
- AR모형에서 계수와 모형의 자기상관계수와의 관계를 나타낸 식

#### AR (p)모형의 정상성 조건

- $Z_t = \phi_1 Z_{t-1}+\phi Z_{t-2}+ ...+\phi_p Z_{t-p}+a_t$
- $\gamma(k)=\phi_1 \gamma(k-1) + \phi_2 \gamma(k-2)+...+\phi_p \gamma(k-p)$
- $\rho(k)= \phi \rho(k-1)+\phi \rho(k-2)+...+\phi_p \rho(k-p), \ k\geq 1$
- 다항식 $\phi_p(z)=0$의 $p$개의 근 $r_i$이 서로 다를 때, Yule-Walker 방정식의 해는 $\rho(k)=A_1 (1/r_1)^k+...+A_p(1/r_p)^k, \ k=0,1,2,...$와 같음. 
  ($\phi_p(z)=1-\phi_1 z - ... \phi_p z^p$)

---

### ==ARIMA 모형과 ARMA모형의 차이는 뭔가?==

- 시계열 추세가 있는 경우 차분을 할 수 있는데 d차 차분한 식은 다음과 같이 표현됨.
  - $\Delta^d Z_t = (1-B)^dZ_t$
- d차 차분 후 시계열이 ARMA (p,q)모형을 따르면, 원 시계열이 ARIMA(p, d, q)를 따른다고 한다.
  - $\phi_p(B) (1-B)^d Z_t = \theta_q (B) a_t$
- ARIMA 모형 중에서 특히 AR부분이 없는 모형을 IMA모형이라고 한다. 즉, ARIMA(p, d, q)모형에서 $p=0$인 경우를 IMA(d, q)모형이라고 한다.
  - $(1-B)^d Z_t = \theta_q (b) a_t$

---

### ==왜 $v_{n,1}=\sigma_a^2$인가?==

- 정의에 따르면, $v_{n,k}=Var[e_{n,k}]$이며, $e_{n,k}=Z_{n,k}-f_{n,k}$
- $e_{n,1}=Z_{n+1}-f_{n,1}$이며, 이는 곧 $e_{n,1}=a_{n+1}$
- 따라서, $Var[e_{n,1}]=Var[a_{n+1}]=\sigma_a^2$

---

### ==Stationary / Invertible==

#### AR 모형

- 정상성: $\phi_p(z)=0$의 p개의 근 각각의 크기가 1보다 커야한다.

#### MA모형

- 정상성: $\Sigma_{i=1}^{q}\theta^2 < \infin$
- 가역성: $\theta_q(z)=1-\theta_1z-\theta_2z^2-...-\theta_qz^q=0$의 q개의 근 각각의 크기가 1보다 커야한다.

#### ARMA모형

- 정상성: $\phi_p(z)=0$의 각 근의 크기가 1보다 커야한다.
- 가역성: $\theta_q(z)=0$의 각 근의 크기가 1보다 커야한다.
- 단, $\phi_p(z)=0$ 및 $\theta_q(z)=0$에서 공통적인 근이 없어야 한다.

---

### ==스펙트럼 밀도함수==

- 기댓값이 0인 정상적 시계열에 대한 자기공분산함수의 절댓값 합이 유한할 때, 시계열의 스펙트럼 밀도함수는 다음과 같다.
  - $e^{-i h\omega}=cos(h\omega)-i sin(h\omega)$
  - $f(\omega)=\frac{1}{2\pi}[\gamma(0)+2 \Sigma_{h=1}^{\infin}\gamma(h)cos(h \omega)]$

#### ARMA모형의 스펙트럼

- ARMA모형이 $\phi_p(B)Z_t = \theta_q (B)a_t$일 때, 스펙트럼은 다음과 같음.
  - $f(\omega)=\frac{\sigma_a^2}{2 \pi}|\frac{\theta_q(e^{-i\omega})}{\phi_p(e^{-i \omega})}|^2$

