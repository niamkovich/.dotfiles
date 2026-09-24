// ── Configuration ────────────────────────────────────────────────────────────
const vec4  TRAIL_COLOR        = vec4(0.0, 0.55, 0.55, 1.0); // main trail color
const vec4  TRAIL_COLOR_ACCENT = vec4(0.0, 0.3,  0.6,  1.0); // inner glow color
const float SATURATION         = 0.8;  // 0 = grayscale, 1 = original, >1 = vivid
const float DURATION           = 0.3;  // trail fade duration in seconds
const float TRAIL_SOFTNESS     = 0.007; // trail edge blur radius
const float CURSOR_GLOW_OFFSET = 0.002; // glow spread around cursor
const float CURSOR_GLOW_SIZE   = 0.004; // glow blur radius
// ─────────────────────────────────────────────────────────────────────────────

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// https://iquilezles.org/articles/distfunctions2d/
float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    d = min(d, dot(p - proj, p - proj));
    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    s *= mix(1.0, -1.0, step(0.5, allCond + noneCond));
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);
    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);
    return s * sqrt(d);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float determineStartVertexFactor(vec2 c, vec2 p) {
    float condition1 = step(p.x, c.x) * step(c.y, p.y);
    float condition2 = step(c.x, p.x) * step(p.y, c.y);
    return 1.0 - max(condition1, condition2);
}

vec2 rectCenter(vec4 r) {
    return r.xy + r.zw * vec2(0.5, -0.5);
}

float easeOutCubic(float x) {
    return pow(1.0 - x, 3.0);
}

vec4 adjustSat(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.));
    return mix(vec4(gray), color, factor);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.);

    vec4 currentCursor  = vec4(norm(iCurrentCursor.xy,  1.), norm(iCurrentCursor.zw,  0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    vec2 centerCurrent  = rectCenter(currentCursor);
    vec2 centerPrevious = rectCenter(previousCursor);

    float vertexFactor         = determineStartVertexFactor(currentCursor.xy, previousCursor.xy);
    float invertedVertexFactor = 1.0 - vertexFactor;
    float zV  = currentCursor.z * vertexFactor;
    float zIV = currentCursor.z * invertedVertexFactor;

    vec2 v0 = vec2(currentCursor.x  + zV,  currentCursor.y  - currentCursor.w);
    vec2 v1 = vec2(currentCursor.x  + zIV, currentCursor.y);
    vec2 v2 = vec2(previousCursor.x + zIV, previousCursor.y);
    vec2 v3 = vec2(previousCursor.x + zV,  previousCursor.y - previousCursor.w);

    float sdfCursor = getSdfRectangle(vu, centerCurrent, currentCursor.zw * 0.5);
    float sdfTrail  = getSdfParallelogram(vu, v0, v1, v2, v3);

    float easedProgress = easeOutCubic(clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0));
    float lineLength    = distance(centerCurrent, centerPrevious);

    vec4  colorMain   = adjustSat(TRAIL_COLOR,        SATURATION);
    vec4  colorAccent = adjustSat(TRAIL_COLOR_ACCENT,  SATURATION);
    float trailEdge   = sdfTrail + TRAIL_SOFTNESS;

    vec4 trail = mix(colorAccent, fragColor, 1. - smoothstep(0., trailEdge, TRAIL_SOFTNESS));
    trail = mix(colorMain,   trail, 1. - smoothstep(0., trailEdge, TRAIL_SOFTNESS - 0.001));
    trail = mix(trail, colorMain,   step(trailEdge, 0.));
    float cursorEdge = sdfCursor + CURSOR_GLOW_OFFSET;
    trail = mix(colorAccent, trail, 1. - smoothstep(0., cursorEdge, CURSOR_GLOW_SIZE));
    trail = mix(colorMain,   trail, 1. - smoothstep(0., cursorEdge, CURSOR_GLOW_SIZE));
    fragColor = mix(trail, fragColor, 1. - smoothstep(0., sdfCursor, easedProgress * lineLength));
}
