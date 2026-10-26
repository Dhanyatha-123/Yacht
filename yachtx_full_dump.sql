--
-- PostgreSQL database dump
--

\restrict f654iOrOTSkxLVhrazakYMbmonbU8eXreZagN12jxU21ihcg44c4jIYDeVkzqBh

-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_notifications (
    id integer NOT NULL,
    type character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    message text,
    entity_type character varying(50),
    entity_id integer,
    is_read boolean DEFAULT false,
    read_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.admin_notifications OWNER TO postgres;

--
-- Name: admin_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_notifications_id_seq OWNER TO postgres;

--
-- Name: admin_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_notifications_id_seq OWNED BY public.admin_notifications.id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    id integer NOT NULL,
    admin_id integer,
    action_type character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id integer NOT NULL,
    old_values jsonb,
    new_values jsonb,
    reason text,
    ip_address character varying(45),
    user_agent text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.audit_logs_id_seq OWNER TO postgres;

--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_id_seq OWNED BY public.audit_logs.id;


--
-- Name: boat_comparisons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_comparisons (
    id integer NOT NULL,
    user_id integer,
    boat_ids integer[] NOT NULL,
    name character varying(100),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.boat_comparisons OWNER TO postgres;

--
-- Name: boat_comparisons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boat_comparisons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boat_comparisons_id_seq OWNER TO postgres;

--
-- Name: boat_comparisons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boat_comparisons_id_seq OWNED BY public.boat_comparisons.id;


--
-- Name: boat_equipment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_equipment (
    id integer NOT NULL,
    boat_id integer NOT NULL,
    refrigerator text,
    stove text,
    oven_microwave text,
    coffee_maker text,
    vacuum text,
    washer_dryer text,
    galley_other text,
    tv text,
    dvd text,
    vcr text,
    satellite_tv text,
    stereo_cd_tape text,
    satellite_radio text,
    entertainment_other text,
    vhf text,
    radar text,
    gps_chart_plotter text,
    depth_finder text,
    forward_sonar text,
    fish_finder text,
    autopilot text,
    navigation_other text,
    canvas text,
    davit text,
    dinghy_motor text,
    pulpit text,
    windlass text,
    swim_platform text,
    deck_shower text,
    fresh_raw_water_washdown text,
    life_raft text,
    epirb text,
    deck_other text,
    generator_size_kw numeric,
    generator_manufacturer text,
    inverter text,
    battery_charger text,
    iso_boost text,
    climate_reverse_cycle_ac text,
    trim_tabs text,
    stabilizer text,
    cablemaster text,
    watermaker text,
    spare_props text,
    bilge_pumps text,
    bow_thruster text,
    other_systems_other text,
    engine_number text,
    engine_manufacturer text,
    engine_model text,
    engine_hp text,
    racor_fuel_filters text,
    airseps text,
    synchronizer text,
    engine_other text,
    outriggers text,
    fighting_chair text,
    live_well text,
    tackle_center text,
    launchers text,
    fishing_other text,
    sails text,
    self_furling_lazy_jacks text,
    winches_hardware text,
    helm text,
    sailing_other text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.boat_equipment OWNER TO postgres;

--
-- Name: boat_equipment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boat_equipment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boat_equipment_id_seq OWNER TO postgres;

--
-- Name: boat_equipment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boat_equipment_id_seq OWNED BY public.boat_equipment.id;


--
-- Name: boat_images; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_images (
    id integer NOT NULL,
    boat_id integer,
    image_url character varying(500) NOT NULL,
    file_name character varying(255),
    file_size integer,
    sort_order integer DEFAULT 0,
    is_primary boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    thumbnail_url character varying(500),
    category character varying(50) DEFAULT 'exterior'::character varying
);


ALTER TABLE public.boat_images OWNER TO postgres;

--
-- Name: boat_photos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_photos (
    id integer NOT NULL,
    boat_id integer NOT NULL,
    file_path text NOT NULL,
    file_name text NOT NULL,
    file_size_bytes integer NOT NULL,
    mime_type text NOT NULL,
    width integer,
    height integer,
    group_key text DEFAULT 'exterior'::text NOT NULL,
    is_primary boolean DEFAULT false NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.boat_photos OWNER TO postgres;

--
-- Name: boat_photos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boat_photos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boat_photos_id_seq OWNER TO postgres;

--
-- Name: boat_photos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boat_photos_id_seq OWNED BY public.boat_photos.id;


--
-- Name: boat_restricted; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_restricted (
    id integer NOT NULL,
    boat_id integer NOT NULL,
    uscg_official_number character varying(50),
    state_registration_number character varying(100),
    hull_identification_number character varying(50),
    legal_vessel_name character varying(255),
    cruising_speed_knots numeric(6,2),
    cruising_rpm integer,
    cruising_fuel_gph numeric(8,2),
    max_speed_knots numeric(6,2),
    max_rpm integer,
    max_fuel_gph numeric(8,2),
    engine_hours_port integer,
    engine_hours_starboard integer,
    generator_hours integer,
    engine_serial_number_port character varying(100),
    engine_serial_number_starboard character varying(100),
    owners text[],
    total_interest_owned_percent numeric(5,2),
    location_name character varying(255),
    location_website character varying(500),
    location_contact_name character varying(255),
    location_phone_office character varying(50),
    location_phone_mobile character varying(50),
    location_email character varying(255),
    address_country character varying(100),
    address_street character varying(255),
    address_city character varying(100),
    address_state character varying(100),
    address_postal_code character varying(20),
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT boat_restricted_total_interest_owned_percent_check CHECK (((total_interest_owned_percent IS NULL) OR ((total_interest_owned_percent >= (0)::numeric) AND (total_interest_owned_percent <= (100)::numeric))))
);


ALTER TABLE public.boat_restricted OWNER TO postgres;

--
-- Name: boat_restricted_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boat_restricted_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boat_restricted_id_seq OWNER TO postgres;

--
-- Name: boat_restricted_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boat_restricted_id_seq OWNED BY public.boat_restricted.id;


--
-- Name: boat_specifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boat_specifications (
    id integer NOT NULL,
    boat_id integer,
    category character varying(50) NOT NULL,
    spec_key character varying(100) NOT NULL,
    spec_value text,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.boat_specifications OWNER TO postgres;

--
-- Name: boat_specifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boat_specifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boat_specifications_id_seq OWNER TO postgres;

--
-- Name: boat_specifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boat_specifications_id_seq OWNED BY public.boat_specifications.id;


--
-- Name: boats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.boats (
    id integer NOT NULL,
    user_id integer,
    title character varying(255) NOT NULL,
    manufacturer character varying(255),
    model character varying(255),
    year integer,
    yacht_type character varying(100),
    price numeric(15,2),
    currency character varying(10) DEFAULT 'USD'::character varying,
    location_city character varying(255),
    location_state character varying(255),
    location_country character varying(255),
    description text,
    length_ft numeric(10,2),
    beam_ft numeric(10,2),
    draft_ft numeric(10,2),
    displacement_lbs integer,
    fuel_type character varying(50),
    hull_material character varying(100),
    fuel_capacity_gallons integer,
    water_capacity_gallons integer,
    engine_make character varying(255),
    engine_model character varying(255),
    engine_hp integer,
    engine_hours integer,
    generator_kw numeric(10,2),
    staterooms integer,
    heads integer,
    status character varying(50) DEFAULT 'active'::character varying,
    views_count integer DEFAULT 0,
    featured boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    make character varying(100),
    asking_price numeric(12,2),
    vessel_type character varying(50),
    location character varying(255),
    yachtx_id character varying(50),
    inquiries_count integer DEFAULT 0,
    deleted_at timestamp without time zone,
    status_change_reason text,
    status_changed_by integer,
    status_changed_at timestamp without time zone,
    length_in numeric(4,2),
    deck_superstructure_condition text,
    hull_sides_condition text,
    interior_condition text,
    bilge_engine_room_condition text,
    bridge_condition text,
    bottom_condition text,
    general_condition_other text,
    cockpit_aft_deck text,
    master_stateroom text,
    other_staterooms text,
    galley_dinette text,
    salon text,
    layout_other text,
    beam_in numeric(4,2),
    draft_in numeric(4,2),
    bridge_clearance_ft numeric(6,2),
    bridge_clearance_in numeric(4,2),
    fuel_capacity_gal integer,
    water_capacity_gal integer,
    holding_tank_gal integer,
    helms integer DEFAULT 0,
    engine_count integer DEFAULT 1,
    generator_make character varying(100)
);


ALTER TABLE public.boats OWNER TO postgres;

--
-- Name: boats_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.boats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.boats_id_seq OWNER TO postgres;

--
-- Name: boats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.boats_id_seq OWNED BY public.boats.id;


--
-- Name: contact_admin_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_admin_notes (
    id integer NOT NULL,
    contact_submission_id integer,
    admin_id integer,
    note text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.contact_admin_notes OWNER TO postgres;

--
-- Name: contact_admin_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_admin_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_admin_notes_id_seq OWNER TO postgres;

--
-- Name: contact_admin_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_admin_notes_id_seq OWNED BY public.contact_admin_notes.id;


--
-- Name: contact_submissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact_submissions (
    id integer NOT NULL,
    name character varying(100),
    email character varying(255) NOT NULL,
    phone character varying(50),
    message text NOT NULL,
    status character varying(20) DEFAULT 'new'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    priority character varying(20) DEFAULT 'normal'::character varying,
    assigned_to integer,
    CONSTRAINT contact_submissions_priority_check CHECK (((priority)::text = ANY ((ARRAY['low'::character varying, 'normal'::character varying, 'high'::character varying, 'urgent'::character varying])::text[])))
);


ALTER TABLE public.contact_submissions OWNER TO postgres;

--
-- Name: contact_submissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_submissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_submissions_id_seq OWNER TO postgres;

--
-- Name: contact_submissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_submissions_id_seq OWNED BY public.contact_submissions.id;


--
-- Name: deal_admin_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deal_admin_notes (
    id integer NOT NULL,
    deal_id integer,
    admin_id integer,
    note text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.deal_admin_notes OWNER TO postgres;

--
-- Name: deal_admin_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deal_admin_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deal_admin_notes_id_seq OWNER TO postgres;

--
-- Name: deal_admin_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deal_admin_notes_id_seq OWNED BY public.deal_admin_notes.id;


--
-- Name: deals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deals (
    id integer NOT NULL,
    boat_id integer,
    seller_id integer,
    buyer_id integer,
    status character varying(20) DEFAULT 'initiated'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    closed_at timestamp without time zone,
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT deals_status_check CHECK (((status)::text = ANY ((ARRAY['initiated'::character varying, 'in_discussion'::character varying, 'sold'::character varying, 'cancelled'::character varying])::text[])))
);


ALTER TABLE public.deals OWNER TO postgres;

--
-- Name: deals_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deals_id_seq OWNER TO postgres;

--
-- Name: deals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deals_id_seq OWNED BY public.deals.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorites (
    id integer NOT NULL,
    user_id integer,
    boat_id integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.favorites OWNER TO postgres;

--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.favorites_id_seq OWNER TO postgres;

--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: images_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.images_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.images_id_seq OWNER TO postgres;

--
-- Name: images_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.images_id_seq OWNED BY public.boat_images.id;


--
-- Name: inquiries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inquiries (
    id integer NOT NULL,
    boat_id integer,
    user_id integer,
    buyer_name character varying(255),
    buyer_email character varying(255),
    buyer_phone character varying(50),
    message text NOT NULL,
    status character varying(50) DEFAULT 'new'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    read_at timestamp without time zone,
    responded_at timestamp without time zone,
    sender_id integer,
    receiver_id integer,
    sender_name character varying(100),
    sender_email character varying(255) NOT NULL,
    sender_phone character varying(50),
    subject character varying(255),
    replied_at timestamp without time zone,
    first_response_at timestamp without time zone,
    sla_target_hours integer DEFAULT 24,
    sla_breached boolean DEFAULT false,
    deal_id integer
);


ALTER TABLE public.inquiries OWNER TO postgres;

--
-- Name: inquiries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inquiries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inquiries_id_seq OWNER TO postgres;

--
-- Name: inquiries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inquiries_id_seq OWNED BY public.inquiries.id;


--
-- Name: inquiry_admin_notes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inquiry_admin_notes (
    id integer NOT NULL,
    inquiry_id integer,
    admin_id integer,
    note text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.inquiry_admin_notes OWNER TO postgres;

--
-- Name: inquiry_admin_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inquiry_admin_notes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inquiry_admin_notes_id_seq OWNER TO postgres;

--
-- Name: inquiry_admin_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inquiry_admin_notes_id_seq OWNED BY public.inquiry_admin_notes.id;


--
-- Name: inquiry_tags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inquiry_tags (
    id integer NOT NULL,
    inquiry_id integer,
    tag character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.inquiry_tags OWNER TO postgres;

--
-- Name: inquiry_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inquiry_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.inquiry_tags_id_seq OWNER TO postgres;

--
-- Name: inquiry_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inquiry_tags_id_seq OWNED BY public.inquiry_tags.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    inquiry_id integer,
    sender_id integer,
    message text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    read_at timestamp without time zone
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.messages_id_seq OWNER TO postgres;

--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: page_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.page_views (
    id integer NOT NULL,
    boat_id integer,
    user_id integer,
    ip_address character varying(45),
    user_agent text,
    referrer character varying(500),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.page_views OWNER TO postgres;

--
-- Name: page_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.page_views_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_views_id_seq OWNER TO postgres;

--
-- Name: page_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.page_views_id_seq OWNED BY public.page_views.id;


--
-- Name: price_alerts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_alerts (
    id integer NOT NULL,
    user_id integer,
    boat_id integer,
    original_price numeric(12,2),
    target_price numeric(12,2),
    alert_on_any_drop boolean DEFAULT true,
    is_active boolean DEFAULT true,
    last_notified_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.price_alerts OWNER TO postgres;

--
-- Name: price_alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_alerts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_alerts_id_seq OWNER TO postgres;

--
-- Name: price_alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_alerts_id_seq OWNED BY public.price_alerts.id;


--
-- Name: price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_history (
    id integer NOT NULL,
    boat_id integer,
    old_price numeric(12,2),
    new_price numeric(12,2),
    changed_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.price_history OWNER TO postgres;

--
-- Name: price_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.price_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.price_history_id_seq OWNER TO postgres;

--
-- Name: price_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.price_history_id_seq OWNED BY public.price_history.id;


--
-- Name: saved_searches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_searches (
    id integer NOT NULL,
    user_id integer,
    name character varying(100),
    filters jsonb,
    notify_new_listings boolean DEFAULT true,
    notify_price_drops boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.saved_searches OWNER TO postgres;

--
-- Name: saved_searches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.saved_searches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saved_searches_id_seq OWNER TO postgres;

--
-- Name: saved_searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.saved_searches_id_seq OWNED BY public.saved_searches.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(255),
    phone character varying(50),
    role character varying(50) DEFAULT 'buyer'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    first_name character varying(100),
    last_name character varying(100),
    is_active boolean DEFAULT true,
    avatar_url character varying(500),
    email_verified boolean DEFAULT false,
    email_verification_token character varying(255),
    password_reset_token character varying(255),
    password_reset_expires timestamp without time zone,
    last_login timestamp without time zone,
    deleted_at timestamp without time zone,
    is_support_admin boolean DEFAULT false,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['buyer'::character varying, 'seller'::character varying, 'finance'::character varying, 'insurance'::character varying, 'settlement'::character varying, 'surveyor'::character varying, 'admin'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: admin_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_notifications ALTER COLUMN id SET DEFAULT nextval('public.admin_notifications_id_seq'::regclass);


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN id SET DEFAULT nextval('public.audit_logs_id_seq'::regclass);


--
-- Name: boat_comparisons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_comparisons ALTER COLUMN id SET DEFAULT nextval('public.boat_comparisons_id_seq'::regclass);


--
-- Name: boat_equipment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_equipment ALTER COLUMN id SET DEFAULT nextval('public.boat_equipment_id_seq'::regclass);


--
-- Name: boat_images id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_images ALTER COLUMN id SET DEFAULT nextval('public.images_id_seq'::regclass);


--
-- Name: boat_photos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_photos ALTER COLUMN id SET DEFAULT nextval('public.boat_photos_id_seq'::regclass);


--
-- Name: boat_restricted id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_restricted ALTER COLUMN id SET DEFAULT nextval('public.boat_restricted_id_seq'::regclass);


--
-- Name: boat_specifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_specifications ALTER COLUMN id SET DEFAULT nextval('public.boat_specifications_id_seq'::regclass);


--
-- Name: boats id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats ALTER COLUMN id SET DEFAULT nextval('public.boats_id_seq'::regclass);


--
-- Name: contact_admin_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_admin_notes ALTER COLUMN id SET DEFAULT nextval('public.contact_admin_notes_id_seq'::regclass);


--
-- Name: contact_submissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_submissions ALTER COLUMN id SET DEFAULT nextval('public.contact_submissions_id_seq'::regclass);


--
-- Name: deal_admin_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal_admin_notes ALTER COLUMN id SET DEFAULT nextval('public.deal_admin_notes_id_seq'::regclass);


--
-- Name: deals id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals ALTER COLUMN id SET DEFAULT nextval('public.deals_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: inquiries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries ALTER COLUMN id SET DEFAULT nextval('public.inquiries_id_seq'::regclass);


--
-- Name: inquiry_admin_notes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_admin_notes ALTER COLUMN id SET DEFAULT nextval('public.inquiry_admin_notes_id_seq'::regclass);


--
-- Name: inquiry_tags id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_tags ALTER COLUMN id SET DEFAULT nextval('public.inquiry_tags_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: page_views id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_views ALTER COLUMN id SET DEFAULT nextval('public.page_views_id_seq'::regclass);


--
-- Name: price_alerts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts ALTER COLUMN id SET DEFAULT nextval('public.price_alerts_id_seq'::regclass);


--
-- Name: price_history id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history ALTER COLUMN id SET DEFAULT nextval('public.price_history_id_seq'::regclass);


--
-- Name: saved_searches id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_searches ALTER COLUMN id SET DEFAULT nextval('public.saved_searches_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: admin_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_notifications (id, type, title, message, entity_type, entity_id, is_read, read_at, created_at) FROM stdin;
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (id, admin_id, action_type, entity_type, entity_id, old_values, new_values, reason, ip_address, user_agent, created_at) FROM stdin;
1	7	user_bulk_activate	user	38	\N	{"action": "activate"}	\N	\N	\N	2026-02-05 19:40:58.005693
2	7	deal_status_change	deal	2	{"status": "initiated"}	{"reason": "Buyer and seller have begun negotiations", "status": "in_discussion"}	Buyer and seller have begun negotiations	\N	\N	2026-02-05 21:27:39.958346
3	7	deal_status_change	deal	2	{"status": "in_discussion"}	{"reason": "Deal finalized. Buyer has completed purchase.", "status": "sold"}	Deal finalized. Buyer has completed purchase.	\N	\N	2026-02-05 21:27:39.974354
4	8	restricted_create	boat_restricted	54	\N	\N	\N	\N	\N	2026-02-10 00:45:12.709939
\.


--
-- Data for Name: boat_comparisons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_comparisons (id, user_id, boat_ids, name, created_at) FROM stdin;
\.


--
-- Data for Name: boat_equipment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_equipment (id, boat_id, refrigerator, stove, oven_microwave, coffee_maker, vacuum, washer_dryer, galley_other, tv, dvd, vcr, satellite_tv, stereo_cd_tape, satellite_radio, entertainment_other, vhf, radar, gps_chart_plotter, depth_finder, forward_sonar, fish_finder, autopilot, navigation_other, canvas, davit, dinghy_motor, pulpit, windlass, swim_platform, deck_shower, fresh_raw_water_washdown, life_raft, epirb, deck_other, generator_size_kw, generator_manufacturer, inverter, battery_charger, iso_boost, climate_reverse_cycle_ac, trim_tabs, stabilizer, cablemaster, watermaker, spare_props, bilge_pumps, bow_thruster, other_systems_other, engine_number, engine_manufacturer, engine_model, engine_hp, racor_fuel_filters, airseps, synchronizer, engine_other, outriggers, fighting_chair, live_well, tackle_center, launchers, fishing_other, sails, self_furling_lazy_jacks, winches_hardware, helm, sailing_other, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: boat_images; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_images (id, boat_id, image_url, file_name, file_size, sort_order, is_primary, created_at, thumbnail_url, category) FROM stdin;
1	1	/uploads/bannernew_100.jpg	\N	\N	0	t	2026-01-04 18:22:03.561241	\N	main
2	2	/uploads/bannernew_150.jpg	\N	\N	0	t	2026-01-04 18:22:03.574216	\N	main
3	3	/uploads/bannernew1_7.jpg	\N	\N	0	t	2026-01-04 18:22:03.578543	\N	main
4	4	/uploads/bannernew_152.jpg	\N	\N	0	t	2026-01-04 18:22:03.582447	\N	main
5	5	/uploads/bannernew_163.jpg	\N	\N	0	t	2026-01-04 18:22:03.59065	\N	main
6	6	/uploads/bannernew_130.jpg	\N	\N	0	t	2026-01-04 18:22:03.593333	\N	main
7	7	/uploads/bannernew1_6.jpg	\N	\N	0	t	2026-01-04 18:22:03.595597	\N	main
8	8	/uploads/bannernew_164.jpg	\N	\N	0	t	2026-01-04 18:22:03.598947	\N	main
9	9	/uploads/bannernew_117.jpg	\N	\N	0	t	2026-01-04 18:22:03.606212	\N	main
10	10	/uploads/bannernew1_3.jpg	\N	\N	0	t	2026-01-04 18:22:03.609741	\N	main
11	11	/uploads/bannernew_148.jpg	\N	\N	0	t	2026-01-04 18:22:03.615517	\N	main
12	12	/uploads/bannernew2.jpg	\N	\N	0	t	2026-01-04 18:22:03.622788	\N	main
13	13	/uploads/bannernew_166.jpg	\N	\N	0	t	2026-01-04 18:22:03.627115	\N	main
14	14	/uploads/bannernew_169.jpg	\N	\N	0	t	2026-01-04 18:22:03.630274	\N	main
15	15	/uploads/bannernew_154.jpg	\N	\N	0	t	2026-01-04 18:22:03.634104	\N	main
16	16	/uploads/bannernew_156.jpg	\N	\N	0	t	2026-01-04 18:22:03.64201	\N	main
17	17	/uploads/bannernew_171.jpg	\N	\N	0	t	2026-01-04 18:22:03.644866	\N	main
18	18	/uploads/bannernew_140.jpg	\N	\N	0	t	2026-01-04 18:22:03.64801	\N	main
19	19	/uploads/bannernew_168.jpg	\N	\N	0	t	2026-01-04 18:22:03.652286	\N	main
20	20	/uploads/bannernew_162.jpg	\N	\N	0	t	2026-01-04 18:22:03.658574	\N	main
21	21	/uploads/bannernew_134.jpg	\N	\N	0	t	2026-01-04 18:22:03.66126	\N	main
22	22	/uploads/bannernew_116.jpg	\N	\N	0	t	2026-01-04 18:22:03.664211	\N	main
23	23	/uploads/bannernew_170.jpg	\N	\N	0	t	2026-01-04 18:22:03.666978	\N	main
24	1	/images/boats/bannernew_117.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
25	1	/images/boats-detail/hanse-interior-1.jpg	\N	\N	2	f	2026-01-05 01:07:28.886599	\N	interior
26	2	/images/boats/bannernew_163.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
27	2	/images/boats-detail/dufour-interior-1.jpg	\N	\N	2	f	2026-01-05 01:07:28.886599	\N	interior
28	3	/images/boats/bannernew1_3.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
29	4	/images/boats/bannernew_170.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
30	5	/images/boats/bannernew_148.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
31	6	/images/boats/bannernew2.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
32	7	/images/boats/bannernew_130.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
33	8	/images/boats/bannernew1_6.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
34	9	/images/boats/bannernew_162.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
35	10	/images/boats/bannernew_100.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
36	11	/images/boats/bannernew_164.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
37	12	/images/boats/bannernew_156.jpg	\N	\N	1	t	2026-01-05 01:07:28.886599	\N	main
41	63	/images/boats/lescinq/1.webp	\N	\N	0	t	2026-02-05 21:09:41.845719	\N	main
42	63	/images/boats/lescinq/2.webp	\N	\N	1	f	2026-02-05 21:09:41.852467	\N	exterior
43	63	/images/boats/lescinq/3.webp	\N	\N	2	f	2026-02-05 21:09:41.855243	\N	exterior
\.


--
-- Data for Name: boat_photos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_photos (id, boat_id, file_path, file_name, file_size_bytes, mime_type, width, height, group_key, is_primary, sort_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: boat_restricted; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_restricted (id, boat_id, uscg_official_number, state_registration_number, hull_identification_number, legal_vessel_name, cruising_speed_knots, cruising_rpm, cruising_fuel_gph, max_speed_knots, max_rpm, max_fuel_gph, engine_hours_port, engine_hours_starboard, generator_hours, engine_serial_number_port, engine_serial_number_starboard, owners, total_interest_owned_percent, location_name, location_website, location_contact_name, location_phone_office, location_phone_mobile, location_email, address_country, address_street, address_city, address_state, address_postal_code, created_at, updated_at) FROM stdin;
1	54	\N	\N	US-TST-12345	Test Vessel One	12.50	\N	\N	22.00	\N	\N	150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	US	\N	\N	FL	\N	2026-02-10 00:45:12.706087	2026-02-10 00:45:12.706087
\.


--
-- Data for Name: boat_specifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boat_specifications (id, boat_id, category, spec_key, spec_value, created_at) FROM stdin;
1	1	navigation	autopilot	Raymarine Evolution	2026-01-05 01:07:28.922953
2	1	navigation	gps_plotter	Raymarine Axiom 9	2026-01-05 01:07:28.922953
3	1	navigation	vhf	Standard Horizon	2026-01-05 01:07:28.922953
4	1	navigation	radar	Raymarine Quantum	2026-01-05 01:07:28.922953
5	1	systems	air_conditioning	Cruisair 16000 BTU	2026-01-05 01:07:28.922953
6	1	systems	watermaker	None	2026-01-05 01:07:28.922953
7	1	deck	windlass	Electric	2026-01-05 01:07:28.922953
8	1	deck	dinghy	None	2026-01-05 01:07:28.922953
9	2	navigation	autopilot	B&G Zeus	2026-01-05 01:07:28.922953
10	2	navigation	gps_plotter	B&G Zeus 12	2026-01-05 01:07:28.922953
11	2	navigation	radar	B&G Halo	2026-01-05 01:07:28.922953
12	2	systems	air_conditioning	Marine Air 48000 BTU	2026-01-05 01:07:28.922953
13	2	systems	watermaker	Spectra Newport 400	2026-01-05 01:07:28.922953
14	2	systems	generator	Onan 9kW	2026-01-05 01:07:28.922953
15	2	deck	windlass	Electric	2026-01-05 01:07:28.922953
16	2	deck	dinghy	AB 10ft with 20hp	2026-01-05 01:07:28.922953
\.


--
-- Data for Name: boats; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.boats (id, user_id, title, manufacturer, model, year, yacht_type, price, currency, location_city, location_state, location_country, description, length_ft, beam_ft, draft_ft, displacement_lbs, fuel_type, hull_material, fuel_capacity_gallons, water_capacity_gallons, engine_make, engine_model, engine_hp, engine_hours, generator_kw, staterooms, heads, status, views_count, featured, created_at, updated_at, make, asking_price, vessel_type, location, yachtx_id, inquiries_count, deleted_at, status_change_reason, status_changed_by, status_changed_at, length_in, deck_superstructure_condition, hull_sides_condition, interior_condition, bilge_engine_room_condition, bridge_condition, bottom_condition, general_condition_other, cockpit_aft_deck, master_stateroom, other_staterooms, galley_dinette, salon, layout_other, beam_in, draft_in, bridge_clearance_ft, bridge_clearance_in, fuel_capacity_gal, water_capacity_gal, holding_tank_gal, helms, engine_count, generator_make) FROM stdin;
2	1	Fountaine Pajot 40 ft Lucia 40 Maestro 2019 YX0100000446	\N	Pajot 40	2019	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.570351	2026-01-04 18:22:03.570351	Fountaine	\N	\N	\N	YX0100000446	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
3	1	Dufour 52 ft 525 Grand Large 2008 YX0100000488	\N	52	2008	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.576461	2026-01-04 18:22:03.576461	Dufour	\N	\N	\N	YX0100000488	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
4	1	Bavaria 46 ft Vision 46 2021 YX0100000461	\N	46	2021	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.580763	2026-01-04 18:22:03.580763	Bavaria	\N	\N	\N	YX0100000461	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
5	1	Dufour 56 ft 56 Exclusive 2020 YX0100000481	\N	56	2020	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.586683	2026-01-04 18:22:03.586683	Dufour	\N	\N	\N	YX0100000481	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
6	1	Fountaine Pajot 42 ft Astrea 42 Owners Version 2024 YX0100000471	\N	Pajot 42	2024	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.592096	2026-01-04 18:22:03.592096	Fountaine	\N	\N	\N	YX0100000471	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
7	1	Kristen 52 ft Pilothouse Explorer Yacht 2002 YX0100000479	\N	52	2002	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.594342	2026-01-04 18:22:03.594342	Kristen	\N	\N	\N	YX0100000479	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
8	1	Regal 33 ft 33 Express 2021 YX0100000469	\N	33	2021	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.597474	2026-01-04 18:22:03.597474	Regal	\N	\N	\N	YX0100000469	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
10	1	lagoon 45 ft Lagoon 450F 450 F 2015 YX0100000454	\N	45	2015	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.607857	2026-01-04 18:22:03.607857	lagoon	\N	\N	\N	YX0100000454	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
11	1	Bavaria 42 ft Virtess 420 Fly 2016 YX0100000453	\N	42	2016	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.613168	2026-01-04 18:22:03.613168	Bavaria	\N	\N	\N	YX0100000453	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
12	1	Great Harbour 35 ft TT-35 2018 YX0100000433	\N	Harbour 35	2018	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.617532	2026-01-04 18:22:03.617532	Great	\N	\N	\N	YX0100000433	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
13	1	Lagoon 45 ft Lagoon 450F 450 F 2017 YX0100000475	\N	45	2017	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.62519	2026-01-04 18:22:03.62519	Lagoon	\N	\N	\N	YX0100000475	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
14	1	Fountaine Pajot 40 ft Lucia 40 Maestro 2017 YX0100000465	\N	Pajot 40	2017	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.628613	2026-01-04 18:22:03.628613	Fountaine	\N	\N	\N	YX0100000465	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
16	1	Jeanneau 42 ft Sun Odyssey 42DS 2009 YX0100000417	\N	42	2009	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.640283	2026-01-04 18:22:03.640283	Jeanneau	\N	\N	\N	YX0100000417	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
17	1	Seawind 38 ft 1160 Lite 2022 YX0100000499	\N	38	2022	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.643495	2026-01-04 18:22:03.643495	Seawind	\N	\N	\N	YX0100000499	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
19	1	Cranchi 43 ft Mediterranee 43 2008 YX0100000492	\N	43	2008	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.649494	2026-01-04 18:22:03.649494	Cranchi	\N	\N	\N	YX0100000492	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
20	1	Hatteras 58 ft 58 Motor Yacht 1987 YX0100000482	\N	58	1987	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.657037	2026-01-04 18:22:03.657037	Hatteras	\N	\N	\N	YX0100000482	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
21	1	Beneteau 57 ft Center Cockpit 2005 YX0100000451	\N	57	2005	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	0	t	2026-01-04 18:22:03.659783	2026-01-04 18:22:03.659783	Beneteau	\N	\N	\N	YX0100000451	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
9	1	Hanse 38 ft 388 2022 YX0100000371	\N	38	2022	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	16	t	2026-01-04 18:22:03.600785	2026-01-04 18:22:03.600785	Hanse	\N	\N	\N	YX0100000371	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
18	1	Island Packet 29 ft  1991 YX0100000431	\N	Packet 29	1991	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	26	t	2026-01-04 18:22:03.64629	2026-01-04 18:22:03.64629	Island	\N	\N	\N	YX0100000431	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
22	1	Hanse 50 ft 508 2021 YX0100000372	\N	50	2021	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	86	t	2026-01-04 18:22:03.662781	2026-01-04 18:22:03.662781	Hanse	\N	\N	\N	YX0100000372	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
15	1	Bayliner 45 ft 4588 Pilothouse Motoryacht 1991 YX0100000460	\N	45	1991	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	92	t	2026-01-04 18:22:03.631798	2026-01-04 18:22:03.631798	Bayliner	\N	\N	\N	YX0100000460	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
1	1	Sea Ray 58 ft Sedan Bridge 2006 YX0100000389	\N	Ray 58	2006	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	76	t	2026-01-04 18:22:03.554592	2026-01-04 18:22:03.554592	Sea	\N	\N	\N	YX0100000389	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
40	7	2015 Pearson 424	\N	424	2015	\N	\N	USD	\N	\N	\N	Work in progress	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	2	f	2026-01-01 03:02:40.883949	2026-01-05 03:02:40.883949	Pearson	165000.00	Sail	Jacksonville, FL	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
38	8	2020 Catalina 385	\N	385	2020	\N	\N	USD	\N	\N	\N	Beautiful Catalina 385 in excellent condition. Owner motivated.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-02 03:02:40.872501	2026-01-05 03:02:40.872501	Catalina	185000.00	Sail	Norfolk, VA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
39	6	2008 Hunter 36	\N	36	2008	\N	\N	USD	\N	\N	\N	Draft listing - needs more details	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	0	f	2025-12-31 03:02:40.883949	2026-01-05 03:02:40.883949	Hunter	125000.00	Sail	Savannah, GA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
54	8	2023 Jeanneau Sun Odyssey 349	\N	Sun Odyssey 349	2023	\N	\N	USD	\N	\N	\N	Brand new Jeanneau 349 ready for delivery. Perfect starter sailboat.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	3	\N	pending	1	f	2026-01-03 03:04:17.421494	2026-02-10 01:18:06.554953	Jeanneau	195000.00	Sail	San Francisco, CA	\N	0	\N	\N	\N	\N	6.00	Good condition	Excellent	\N	\N	\N	Fresh paint	\N	\N	\N	\N	Full galley granite	Spacious main salon	\N	3.00	\N	18.50	\N	\N	\N	40	2	1	\N
45	8	2023 Jeanneau Sun Odyssey 349	\N	Sun Odyssey 349	2023	\N	\N	USD	\N	\N	\N	Brand new Jeanneau 349 ready for delivery. Perfect starter sailboat.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-03 03:03:47.638113	2026-01-05 03:03:47.638113	Jeanneau	195000.00	Sail	San Francisco, CA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
46	9	2019 Beneteau Oceanis 41.1	\N	Oceanis 41.1	2019	\N	\N	USD	\N	\N	\N	Well-maintained Beneteau Oceanis 41.1. Recent survey available.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-04 03:03:47.638113	2026-01-05 03:03:47.638113	Beneteau	225000.00	Sail	Boston, MA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
47	13	2020 Catalina 385	\N	385	2020	\N	\N	USD	\N	\N	\N	Beautiful Catalina 385 in excellent condition. Owner motivated.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-02 03:03:47.638113	2026-01-05 03:03:47.638113	Catalina	185000.00	Sail	Norfolk, VA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
48	8	2008 Hunter 36	\N	36	2008	\N	\N	USD	\N	\N	\N	Draft listing - needs more details	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	0	f	2025-12-31 03:03:47.645355	2026-01-05 03:03:47.645355	Hunter	125000.00	Sail	Savannah, GA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
49	9	2015 Pearson 424	\N	424	2015	\N	\N	USD	\N	\N	\N	Work in progress	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	0	f	2026-01-01 03:03:47.645355	2026-01-05 03:03:47.645355	Pearson	165000.00	Sail	Jacksonville, FL	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
51	9	2012 Catalina 30	\N	30	2012	\N	\N	USD	\N	\N	\N	Sold to private buyer.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sold	0	f	2025-11-21 03:03:47.648571	2026-01-05 03:03:47.648571	Catalina	95000.00	Sail	San Diego, CA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
52	8	2005 ODay 322	\N	322	2005	\N	\N	USD	\N	\N	\N	Listing removed by request.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	archived	0	f	2025-11-06 03:03:47.649372	2026-01-05 03:03:47.649372	ODay	75000.00	Sail	Portland, ME	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
53	9	2011 C&C 34	\N	34	2011	\N	\N	USD	\N	\N	\N	No longer available.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	archived	0	f	2025-10-07 03:03:47.649372	2026-01-05 03:03:47.649372	C&C	115000.00	Sail	Toronto, ON	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
37	7	2019 Beneteau Oceanis 41.1	\N	Oceanis 41.1	2019	\N	\N	USD	\N	\N	\N	Well-maintained Beneteau Oceanis 41.1. Recent survey available.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	9	f	2026-01-04 03:02:40.872501	2026-01-05 03:02:40.872501	Beneteau	225000.00	Sail	Boston, MA	\N	0	\N	Boat needs more photos before approval	7	2026-01-03 03:04:17.450712	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
23	1	Beneteau 50 ft Cyclades 50 2006 YX0100000495	\N	50	2006	\N	\N	USD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	active	160	t	2026-01-04 18:22:03.665516	2026-01-04 18:22:03.665516	Beneteau	\N	\N	\N	YX0100000495	4	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
55	9	2019 Beneteau Oceanis 41.1	\N	Oceanis 41.1	2019	\N	\N	USD	\N	\N	\N	Well-maintained Beneteau Oceanis 41.1. Recent survey available.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-04 03:04:17.421494	2026-01-05 03:04:17.421494	Beneteau	225000.00	Sail	Boston, MA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
56	13	2020 Catalina 385	\N	385	2020	\N	\N	USD	\N	\N	\N	Beautiful Catalina 385 in excellent condition. Owner motivated.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-02 03:04:17.421494	2026-01-05 03:04:17.421494	Catalina	185000.00	Sail	Norfolk, VA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
57	8	2008 Hunter 36	\N	36	2008	\N	\N	USD	\N	\N	\N	Draft listing - needs more details	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	0	f	2025-12-31 03:04:17.431054	2026-01-05 03:04:17.431054	Hunter	125000.00	Sail	Savannah, GA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
58	9	2015 Pearson 424	\N	424	2015	\N	\N	USD	\N	\N	\N	Work in progress	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	draft	0	f	2026-01-01 03:04:17.431054	2026-01-05 03:04:17.431054	Pearson	165000.00	Sail	Jacksonville, FL	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
59	8	2010 Hunter 40	\N	40	2010	\N	\N	USD	\N	\N	\N	This boat has been sold.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sold	0	f	2025-12-06 03:04:17.432873	2026-01-05 03:04:17.432873	Hunter	145000.00	Sail	Miami, FL	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
60	9	2012 Catalina 30	\N	30	2012	\N	\N	USD	\N	\N	\N	Sold to private buyer.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sold	0	f	2025-11-21 03:04:17.432873	2026-01-05 03:04:17.432873	Catalina	95000.00	Sail	San Diego, CA	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
61	8	2005 ODay 322	\N	322	2005	\N	\N	USD	\N	\N	\N	Listing removed by request.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	archived	0	f	2025-11-06 03:04:17.433587	2026-01-05 03:04:17.433587	ODay	75000.00	Sail	Portland, ME	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
62	9	2011 C&C 34	\N	34	2011	\N	\N	USD	\N	\N	\N	No longer available.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	archived	0	f	2025-10-07 03:04:17.433587	2026-01-05 03:04:17.433587	C&C	115000.00	Sail	Toronto, ON	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
36	6	2023 Jeanneau Sun Odyssey 349	\N	Sun Odyssey 349	2023	\N	\N	USD	\N	\N	\N	Brand new Jeanneau 349 ready for delivery. Perfect starter sailboat.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	pending	0	f	2026-01-03 03:02:40.872501	2026-01-05 03:02:40.872501	Jeanneau	195000.00	Sail	San Francisco, CA	\N	0	\N	Boat needs more photos before approval	7	2026-01-03 03:04:17.450712	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
50	8	2010 Hunter 40	\N	40	2010	\N	\N	USD	\N	\N	\N	This boat has been sold.	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sold	0	f	2025-12-06 03:03:47.648571	2026-01-05 03:03:47.648571	Hunter	145000.00	Sail	Miami, FL	\N	0	\N	Boat sold to private buyer	7	2025-12-06 03:04:17.451772	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
63	40	Feadship 75.8m "One" (Les Cinq)	\N	One / Les Cinq	2025	\N	\N	USD	\N	\N	\N	One, now renamed Les Cinq, is a 75.8-metre Feadship superyacht and one of the most significant yacht sales of 2025. Delivered as a new build and first launched in January, she features a striking navy and white exterior designed by Studio De Voogt with naval architecture by Azure Naval Architects.\n\nThe interior, created by Parisian design studio Gilles & Boissier, follows a modern and minimal luxury concept with refined detailing throughout. The yacht is designed for comfort, privacy, and high-end onboard living.\n\nKey features include a dedicated owner's deck, a bridge deck wellness centre, and a glass-bottom swimming pool on the main deck that illuminates the beach club below.\n\nThe yacht was listed with an asking price of €172,500,000 and was represented in the sale by Edmiston and Feadship Resale, with Burgess acting as the buying broker.	248.70	41.00	11.08	\N	Diesel	Steel	\N	\N	\N	\N	\N	\N	\N	\N	\N	sold	16	t	2026-02-05 20:56:10.296191	2026-02-05 21:27:39.974354	Feadship	172500000.00	Motor Yacht	Monaco	\N	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	1	\N
\.


--
-- Data for Name: contact_admin_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_admin_notes (id, contact_submission_id, admin_id, note, created_at, updated_at) FROM stdin;
5	4	7	Customer wants to list a Beneteau 45. High priority - follow up today.	2026-01-04 03:04:31.534548	2026-01-05 03:04:31.534548
6	6	7	URGENT: Customer needs immediate assistance. Called and left voicemail.	2026-01-05 01:04:31.534548	2026-01-05 03:04:31.534548
7	7	7	Customer asked about listing process. Sent detailed email with instructions.	2026-01-03 03:04:31.534548	2026-01-05 03:04:31.534548
\.


--
-- Data for Name: contact_submissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact_submissions (id, name, email, phone, message, status, created_at, priority, assigned_to) FROM stdin;
1	John Doe	john@example.com	555-111-2222	I would like to learn more about listing my boat with YachtX. Please contact me.	new	2026-01-05 01:07:28.94604	normal	\N
7	Emily White	emily@example.com	555-400-5000	I would like to become a seller on your platform. What are the requirements?	read	2026-01-02 03:03:47.650899	normal	\N
8	James Black	james@example.com	555-500-6000	General question about your services. Do you offer boat inspections?	read	2026-01-03 03:03:47.650899	low	\N
9	Patricia Green	patricia@example.com	555-600-7000	Thank you for your help with my listing. Everything is working great!	replied	2025-12-29 03:03:47.650899	low	\N
10	Richard Blue	richard@example.com	555-700-8000	I received your email. Thank you for the information.	replied	2025-12-31 03:03:47.650899	normal	\N
11	Susan Gray	susan@example.com	555-800-9000	Old inquiry - no longer relevant.	archived	2025-12-06 03:03:47.650899	low	\N
12	Thomas Red	thomas@example.com	555-900-0000	Spam submission - can be archived.	archived	2025-12-16 03:03:47.650899	low	\N
16	Emily White	emily@example.com	555-400-5000	I would like to become a seller on your platform. What are the requirements?	read	2026-01-02 03:04:17.440145	normal	\N
17	James Black	james@example.com	555-500-6000	General question about your services. Do you offer boat inspections?	read	2026-01-03 03:04:17.440145	low	\N
18	Patricia Green	patricia@example.com	555-600-7000	Thank you for your help with my listing. Everything is working great!	replied	2025-12-29 03:04:17.440145	low	\N
19	Richard Blue	richard@example.com	555-700-8000	I received your email. Thank you for the information.	replied	2025-12-31 03:04:17.440145	normal	\N
20	Susan Gray	susan@example.com	555-800-9000	Old inquiry - no longer relevant.	archived	2025-12-06 03:04:17.440145	low	\N
21	Thomas Red	thomas@example.com	555-900-0000	Spam submission - can be archived.	archived	2025-12-16 03:04:17.440145	low	\N
4	Robert Johnson	robert@example.com	555-100-2000	I am interested in listing my 2018 Beneteau Oceanis 45. Please contact me to discuss.	new	2026-01-04 03:03:47.650899	high	7
6	Michael Chen	michael@example.com	555-300-4000	URGENT: Need to list my boat ASAP. Please call me immediately.	new	2026-01-05 01:03:47.650899	urgent	7
13	Robert Johnson	robert@example.com	555-100-2000	I am interested in listing my 2018 Beneteau Oceanis 45. Please contact me to discuss.	new	2026-01-04 03:04:17.440145	high	7
15	Michael Chen	michael@example.com	555-300-4000	URGENT: Need to list my boat ASAP. Please call me immediately.	new	2026-01-05 01:04:17.440145	urgent	7
5	Jennifer Lee	jennifer@example.com	555-200-3000	I have questions about the boat listing process. How long does it take?	new	2026-01-04 22:03:47.650899	normal	19
14	Jennifer Lee	jennifer@example.com	555-200-3000	I have questions about the boat listing process. How long does it take?	new	2026-01-04 22:04:17.440145	normal	19
\.


--
-- Data for Name: deal_admin_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deal_admin_notes (id, deal_id, admin_id, note, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: deals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deals (id, boat_id, seller_id, buyer_id, status, created_at, closed_at, updated_at) FROM stdin;
2	63	40	10	sold	2026-02-05 21:27:39.919528	2026-02-05 21:27:39.974354	2026-02-05 21:27:39.974354
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorites (id, user_id, boat_id, created_at) FROM stdin;
9	9	1	2025-12-29 03:02:40.909389
10	9	3	2025-12-30 03:02:40.909389
11	9	7	2026-01-01 03:02:40.909389
12	10	2	2026-01-02 03:02:40.909389
13	10	4	2026-01-03 03:02:40.909389
17	10	5	2025-12-28 03:03:47.654401
18	10	8	2025-12-31 03:03:47.654401
19	16	1	2025-12-29 03:03:47.654401
20	16	3	2025-12-30 03:03:47.654401
21	16	7	2026-01-01 03:03:47.654401
22	17	2	2026-01-02 03:03:47.654401
23	17	4	2026-01-03 03:03:47.654401
36	35	22	2026-01-05 19:40:53.932084
37	35	23	2026-01-05 20:22:43.313575
38	36	23	2026-01-06 02:30:35.723124
39	36	22	2026-01-06 02:30:37.167707
40	36	18	2026-01-06 02:30:39.619242
41	8	17	2026-01-11 02:09:55.897058
42	8	16	2026-01-11 02:09:57.692633
43	8	18	2026-01-11 02:09:59.209073
\.


--
-- Data for Name: inquiries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inquiries (id, boat_id, user_id, buyer_name, buyer_email, buyer_phone, message, status, created_at, read_at, responded_at, sender_id, receiver_id, sender_name, sender_email, sender_phone, subject, replied_at, first_response_at, sla_target_hours, sla_breached, deal_id) FROM stdin;
4	1	\N	Bob Williams	buyer@yachtx.com	555-345-6789	Hi, I sent an inquiry earlier. Just following up to see if you received it.	unread	2026-01-04 03:04:17.434345	\N	\N	10	8	Bob Williams	buyer@yachtx.com	555-345-6789	Follow-up on Hanse 388	\N	\N	24	f	\N
5	2	\N	Alice Martinez	buyer2@yachtx.com	555-890-1234	I am very interested in this boat. Can we schedule a viewing this week?	unread	2026-01-05 01:04:17.434345	\N	\N	16	8	Alice Martinez	buyer2@yachtx.com	555-890-1234	Dufour 56 - Serious Buyer	\N	\N	24	f	\N
6	3	\N	Charlie Anderson	buyer3@yachtx.com	555-901-2345	I have several questions about the Lagoon. Is it available for inspection?	unread	2026-01-05 02:34:17.434345	\N	\N	17	8	Charlie Anderson	buyer3@yachtx.com	555-901-2345	Lagoon 450F Questions	\N	\N	24	f	\N
7	4	\N	Bob Williams	buyer@yachtx.com	555-345-6789	Beautiful boat! What is the asking price?	read	2026-01-03 03:04:17.434345	\N	\N	10	9	Bob Williams	buyer@yachtx.com	555-345-6789	Beneteau 50 Inquiry	\N	\N	24	f	\N
8	5	\N	Alice Martinez	buyer2@yachtx.com	555-890-1234	I would like to know more about the Bavaria 42. Engine hours?	read	2026-01-04 03:04:17.434345	\N	\N	16	9	Alice Martinez	buyer2@yachtx.com	555-890-1234	Bavaria 42 Questions	\N	\N	24	f	\N
9	6	\N	Bob Williams	buyer@yachtx.com	555-345-6789	Interested in this trawler. Please contact me.	replied	2026-01-02 03:04:17.434345	\N	\N	10	8	Bob Williams	buyer@yachtx.com	555-345-6789	Great Harbour TT-35	\N	\N	24	f	\N
10	7	\N	Charlie Anderson	buyer3@yachtx.com	555-901-2345	This is exactly what I am looking for. Let us discuss.	replied	2026-01-01 03:04:17.434345	\N	\N	17	9	Charlie Anderson	buyer3@yachtx.com	555-901-2345	Fountaine Pajot Astrea 42	\N	\N	24	f	\N
11	8	\N	Bob Williams	buyer@yachtx.com	555-345-6789	Old inquiry - no longer interested.	archived	2025-12-06 03:04:17.434345	\N	\N	10	8	Bob Williams	buyer@yachtx.com	555-345-6789	Kristen 52 Inquiry	\N	\N	24	f	\N
24	23	\N	Test Buyer	testbuyer@example.com	5551234567	I am interested in this yacht. Please contact me with more information.	new	2026-01-05 19:56:05.85453	\N	\N	\N	1	Test Buyer	testbuyer@example.com	5551234567	Inquiry about Beneteau 50 ft Cyclades 50 2006 YX0100000495	\N	\N	24	f	\N
25	1	\N	 	chris@gmail.com	9872341124	I am interested in this yacht. Please contact me with more information.	new	2026-01-05 20:00:33.236863	\N	\N	35	1	 	chris@gmail.com	9872341124	Inquiry about Sea Ray 58 ft Sedan Bridge 2006 YX0100000389	\N	\N	24	f	\N
26	23	\N	 	chris@gmail.com	2325252	I am interested in this yacht. Please contact me with more information.	new	2026-01-05 20:24:03.105261	\N	\N	35	1	 	chris@gmail.com	2325252	Inquiry about Beneteau 50 ft Cyclades 50 2006 YX0100000495	\N	\N	24	f	\N
27	23	\N	 	robert@gmail.com	25246343143	I am interested in this yacht. Please contact me with more information.	new	2026-01-05 20:32:25.377366	\N	\N	34	1	 	robert@gmail.com	25246343143	Inquiry about Beneteau 50 ft Cyclades 50 2006 YX0100000495	\N	\N	24	f	\N
28	23	\N	 	esha@hmail.com	2342534637	I am interested in this yacht. Please contact me with more information.	new	2026-01-06 02:30:25.842661	\N	\N	36	1	 	esha@hmail.com	2342534637	Inquiry about Beneteau 50 ft Cyclades 50 2006 YX0100000495	\N	\N	24	f	\N
29	18	\N	John Smith	seller@yachtx.com	123456789768	I am interested in this yacht. Please contact me with more information.	new	2026-01-11 02:10:42.821049	\N	\N	8	1	John Smith	seller@yachtx.com	123456789768	Inquiry about Island Packet 29 ft  1991 YX0100000431	\N	\N	24	f	\N
30	9	\N	John Smith	seller@yachtx.com	123143252352	I am interested in this yacht. Please contact me with more information.	new	2026-01-11 02:16:29.296895	\N	\N	8	1	John Smith	seller@yachtx.com	123143252352	Inquiry about Hanse 38 ft 388 2022 YX0100000371	\N	\N	24	f	\N
32	63	\N	\N	\N	\N	I am very interested in purchasing the Feadship 75.8m 'One' (Les Cinq). I would like to schedule a viewing and discuss the terms. Please contact me at your earliest convenience.	new	2026-02-05 21:27:39.919528	\N	\N	10	40	Bob Williams	buyer@yachtx.com	555-345-6789	Purchase Inquiry - Feadship 75.8m Les Cinq	\N	\N	24	f	2
\.


--
-- Data for Name: inquiry_admin_notes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inquiry_admin_notes (id, inquiry_id, admin_id, note, created_at, updated_at) FROM stdin;
5	4	7	Customer seems very interested. Follow up within 24 hours.	2026-01-04 03:04:25.889825	2026-01-05 03:04:25.889825
6	5	7	Customer seems very interested. Follow up within 24 hours.	2026-01-04 03:04:25.889825	2026-01-05 03:04:25.889825
7	9	7	Replied to customer with all requested information.	2026-01-03 03:04:25.889825	2026-01-05 03:04:25.889825
\.


--
-- Data for Name: inquiry_tags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inquiry_tags (id, inquiry_id, tag, created_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (id, inquiry_id, sender_id, message, created_at, read_at) FROM stdin;
1	6	8	yeah sure tmr	2026-01-05 20:54:51.967037	\N
\.


--
-- Data for Name: page_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.page_views (id, boat_id, user_id, ip_address, user_agent, referrer, created_at) FROM stdin;
1	23	7	::1	\N	\N	2026-01-05 10:03:03.094208
2	23	7	::1	\N	\N	2026-01-05 10:03:03.112587
3	23	7	::1	\N	\N	2026-01-05 16:31:27.84121
4	23	7	::1	\N	\N	2026-01-05 16:31:27.856217
5	23	7	::1	\N	\N	2026-01-05 16:36:57.851251
6	23	7	::1	\N	\N	2026-01-05 16:36:57.862365
7	23	7	::1	\N	\N	2026-01-05 16:42:44.069909
8	23	7	::1	\N	\N	2026-01-05 16:42:44.087739
9	23	7	::1	\N	\N	2026-01-05 17:04:06.235456
10	23	7	::1	\N	\N	2026-01-05 17:04:06.242937
11	23	7	::1	\N	\N	2026-01-05 17:16:53.074637
12	23	7	::1	\N	\N	2026-01-05 17:16:53.103752
13	15	7	::1	\N	\N	2026-01-05 17:26:02.053613
14	15	7	::1	\N	\N	2026-01-05 17:26:02.062969
15	23	7	::1	\N	\N	2026-01-05 17:26:06.774478
16	15	7	::1	\N	\N	2026-01-05 17:26:06.775791
17	23	7	::1	\N	\N	2026-01-05 17:26:06.794181
18	15	7	::1	\N	\N	2026-01-05 17:26:06.794502
19	23	7	::1	\N	\N	2026-01-05 17:26:51.272524
20	15	7	::1	\N	\N	2026-01-05 17:26:51.273669
21	15	7	::1	\N	\N	2026-01-05 17:26:51.308445
22	23	7	::1	\N	\N	2026-01-05 17:26:51.309241
23	23	7	::1	\N	\N	2026-01-05 17:27:09.377426
24	23	7	::1	\N	\N	2026-01-05 17:27:09.385559
25	23	7	::1	\N	\N	2026-01-05 18:00:24.713549
26	23	7	::1	\N	\N	2026-01-05 18:00:24.721798
27	23	7	::1	\N	\N	2026-01-05 18:04:36.812715
28	23	7	::1	\N	\N	2026-01-05 18:04:36.847359
29	23	7	::1	\N	\N	2026-01-05 18:04:38.640251
30	23	7	::1	\N	\N	2026-01-05 18:04:38.652409
31	23	7	::1	\N	\N	2026-01-05 18:05:01.686163
32	23	7	::1	\N	\N	2026-01-05 18:05:01.694794
33	23	7	::1	\N	\N	2026-01-05 18:05:19.520659
34	23	7	::1	\N	\N	2026-01-05 18:05:19.528328
35	15	7	::1	\N	\N	2026-01-05 18:06:00.162852
36	23	7	::1	\N	\N	2026-01-05 18:06:00.163051
37	23	7	::1	\N	\N	2026-01-05 18:06:00.180931
38	15	7	::1	\N	\N	2026-01-05 18:06:00.181204
39	23	7	::1	\N	\N	2026-01-05 18:08:38.553677
40	23	7	::1	\N	\N	2026-01-05 18:08:38.561992
41	23	7	::1	\N	\N	2026-01-05 18:12:00.145034
42	15	7	::1	\N	\N	2026-01-05 18:12:00.147397
43	23	7	::1	\N	\N	2026-01-05 18:12:00.158798
44	15	7	::1	\N	\N	2026-01-05 18:12:00.158903
46	23	7	::1	\N	\N	2026-01-05 18:26:40.121281
45	15	7	::1	\N	\N	2026-01-05 18:26:40.121092
47	23	7	::1	\N	\N	2026-01-05 18:26:40.134319
48	15	7	::1	\N	\N	2026-01-05 18:26:40.134491
49	23	7	::1	\N	\N	2026-01-05 18:47:27.265013
50	23	7	::1	\N	\N	2026-01-05 18:47:27.273759
51	23	7	::1	\N	\N	2026-01-05 18:47:41.469421
52	15	7	::1	\N	\N	2026-01-05 18:47:41.469767
53	23	7	::1	\N	\N	2026-01-05 18:47:41.480542
54	15	7	::1	\N	\N	2026-01-05 18:47:41.481011
55	23	7	::1	\N	\N	2026-01-05 18:52:22.6279
56	23	7	::1	\N	\N	2026-01-05 18:52:22.63389
57	23	7	::1	\N	\N	2026-01-05 18:52:26.573263
58	23	7	::1	\N	\N	2026-01-05 18:52:26.582798
59	23	7	::1	\N	\N	2026-01-05 18:53:14.611145
60	23	7	::1	\N	\N	2026-01-05 18:53:14.62356
61	23	7	::1	\N	\N	2026-01-05 18:53:36.944808
62	23	7	::1	\N	\N	2026-01-05 18:53:36.95684
63	23	7	::1	\N	\N	2026-01-05 18:53:37.687215
64	23	7	::1	\N	\N	2026-01-05 18:53:37.694283
65	23	7	::1	\N	\N	2026-01-05 18:53:45.035224
66	23	7	::1	\N	\N	2026-01-05 18:53:45.045284
67	22	7	::1	\N	\N	2026-01-05 18:54:48.287828
68	22	7	::1	\N	\N	2026-01-05 18:54:48.295215
69	23	7	::1	\N	\N	2026-01-05 18:57:21.644336
70	23	7	::1	\N	\N	2026-01-05 18:57:21.650196
71	22	7	::1	\N	\N	2026-01-05 19:21:49.679079
72	23	7	::1	\N	\N	2026-01-05 19:21:49.679801
73	15	7	::1	\N	\N	2026-01-05 19:21:49.68583
74	23	7	::1	\N	\N	2026-01-05 19:21:49.698286
75	22	7	::1	\N	\N	2026-01-05 19:21:49.698411
76	15	7	::1	\N	\N	2026-01-05 19:21:49.698499
77	23	7	::1	\N	\N	2026-01-05 19:25:57.312592
78	22	7	::1	\N	\N	2026-01-05 19:25:57.314183
79	15	7	::1	\N	\N	2026-01-05 19:25:57.314509
80	23	7	::1	\N	\N	2026-01-05 19:25:57.324
81	22	7	::1	\N	\N	2026-01-05 19:25:57.324126
82	15	7	::1	\N	\N	2026-01-05 19:25:57.324265
83	23	7	::1	\N	\N	2026-01-05 19:25:57.657788
84	23	7	::1	\N	\N	2026-01-05 19:25:57.66587
85	23	34	::1	\N	\N	2026-01-05 19:28:55.049462
86	15	34	::1	\N	\N	2026-01-05 19:28:55.050786
87	22	34	::1	\N	\N	2026-01-05 19:28:55.051586
88	23	34	::1	\N	\N	2026-01-05 19:28:55.067002
89	15	34	::1	\N	\N	2026-01-05 19:28:55.067451
90	22	34	::1	\N	\N	2026-01-05 19:28:55.06765
91	23	34	::1	\N	\N	2026-01-05 19:29:44.415812
92	22	34	::1	\N	\N	2026-01-05 19:29:44.415995
93	22	34	::1	\N	\N	2026-01-05 19:29:44.42598
94	23	34	::1	\N	\N	2026-01-05 19:29:44.426294
95	15	34	::1	\N	\N	2026-01-05 19:29:44.453331
96	15	34	::1	\N	\N	2026-01-05 19:29:44.463709
97	22	35	::1	\N	\N	2026-01-05 19:30:35.360287
98	23	35	::1	\N	\N	2026-01-05 19:30:35.360735
99	15	35	::1	\N	\N	2026-01-05 19:30:35.362752
100	22	35	::1	\N	\N	2026-01-05 19:30:35.371127
101	23	35	::1	\N	\N	2026-01-05 19:30:35.371641
102	15	35	::1	\N	\N	2026-01-05 19:30:35.37408
103	23	35	::1	\N	\N	2026-01-05 19:30:55.216539
104	22	35	::1	\N	\N	2026-01-05 19:30:55.21678
105	22	35	::1	\N	\N	2026-01-05 19:30:55.230034
106	23	35	::1	\N	\N	2026-01-05 19:30:55.230214
107	15	35	::1	\N	\N	2026-01-05 19:30:55.247331
108	15	35	::1	\N	\N	2026-01-05 19:30:55.25481
109	23	35	::1	\N	\N	2026-01-05 19:32:47.672201
110	23	35	::1	\N	\N	2026-01-05 19:32:47.679011
111	23	35	::1	\N	\N	2026-01-05 19:36:39.530896
112	23	35	::1	\N	\N	2026-01-05 19:36:39.537568
113	22	35	::1	\N	\N	2026-01-05 19:40:05.077681
114	15	35	::1	\N	\N	2026-01-05 19:40:05.078835
115	23	35	::1	\N	\N	2026-01-05 19:40:05.079413
116	22	35	::1	\N	\N	2026-01-05 19:40:05.097295
117	15	35	::1	\N	\N	2026-01-05 19:40:05.097446
118	23	35	::1	\N	\N	2026-01-05 19:40:05.097628
119	23	7	::1	\N	\N	2026-01-05 19:40:06.046655
120	23	7	::1	\N	\N	2026-01-05 19:40:06.053809
121	22	35	::1	\N	\N	2026-01-05 19:40:13.867222
122	22	35	::1	\N	\N	2026-01-05 19:40:13.873804
123	23	7	::1	\N	\N	2026-01-05 19:42:49.922839
124	23	7	::1	\N	\N	2026-01-05 19:42:49.935926
125	23	35	::1	\N	\N	2026-01-05 19:42:50.157927
126	15	35	::1	\N	\N	2026-01-05 19:42:50.165513
127	22	35	::1	\N	\N	2026-01-05 19:42:50.165961
128	23	35	::1	\N	\N	2026-01-05 19:42:50.168875
129	15	35	::1	\N	\N	2026-01-05 19:42:50.179316
130	22	35	::1	\N	\N	2026-01-05 19:42:50.179512
131	1	35	::1	\N	\N	2026-01-05 19:42:54.080714
132	1	35	::1	\N	\N	2026-01-05 19:42:54.088626
133	23	7	::1	\N	\N	2026-01-05 19:45:14.295649
134	23	7	::1	\N	\N	2026-01-05 19:45:14.303353
135	1	7	::1	\N	\N	2026-01-05 19:45:25.410805
136	1	7	::1	\N	\N	2026-01-05 19:45:25.419407
137	1	7	::1	\N	\N	2026-01-05 19:46:23.647963
138	1	7	::1	\N	\N	2026-01-05 19:46:23.660679
139	1	35	::1	\N	\N	2026-01-05 19:50:06.537466
140	1	35	::1	\N	\N	2026-01-05 19:50:06.551789
141	1	35	::1	\N	\N	2026-01-05 19:53:10.764719
142	1	35	::1	\N	\N	2026-01-05 19:53:10.772967
143	1	7	::1	\N	\N	2026-01-05 19:53:11.81684
144	1	7	::1	\N	\N	2026-01-05 19:53:11.824862
145	23	7	::1	\N	\N	2026-01-05 19:53:32.440469
146	1	7	::1	\N	\N	2026-01-05 19:53:32.440732
147	23	7	::1	\N	\N	2026-01-05 19:53:32.452226
148	1	7	::1	\N	\N	2026-01-05 19:53:32.45238
149	23	\N	::1	\N	\N	2026-01-05 19:55:50.228399
150	23	\N	::1	\N	\N	2026-01-05 19:55:50.237283
151	1	35	::1	\N	\N	2026-01-05 20:00:12.823727
152	1	35	::1	\N	\N	2026-01-05 20:00:12.8372
153	1	35	::1	\N	\N	2026-01-05 20:04:36.981135
155	23	35	::1	\N	\N	2026-01-05 20:04:36.981521
154	22	35	::1	\N	\N	2026-01-05 20:04:36.981386
156	1	35	::1	\N	\N	2026-01-05 20:04:36.995286
157	23	35	::1	\N	\N	2026-01-05 20:04:36.995451
158	22	35	::1	\N	\N	2026-01-05 20:04:36.99552
159	15	35	::1	\N	\N	2026-01-05 20:04:37.014544
160	15	35	::1	\N	\N	2026-01-05 20:04:37.026184
161	22	35	::1	\N	\N	2026-01-05 20:07:05.186043
162	22	35	::1	\N	\N	2026-01-05 20:07:05.193812
163	22	35	::1	\N	\N	2026-01-05 20:22:38.035202
164	1	35	::1	\N	\N	2026-01-05 20:22:38.035481
165	23	35	::1	\N	\N	2026-01-05 20:22:38.035889
166	1	35	::1	\N	\N	2026-01-05 20:22:38.055753
167	22	35	::1	\N	\N	2026-01-05 20:22:38.055934
168	23	35	::1	\N	\N	2026-01-05 20:22:38.056255
169	15	35	::1	\N	\N	2026-01-05 20:22:38.081849
170	15	35	::1	\N	\N	2026-01-05 20:22:38.092322
171	23	35	::1	\N	\N	2026-01-05 20:22:50.698565
172	23	35	::1	\N	\N	2026-01-05 20:22:50.707066
173	23	7	::1	\N	\N	2026-01-05 20:25:56.62351
174	1	7	::1	\N	\N	2026-01-05 20:25:56.624539
175	22	7	::1	\N	\N	2026-01-05 20:25:56.627626
176	1	7	::1	\N	\N	2026-01-05 20:25:56.681877
177	23	7	::1	\N	\N	2026-01-05 20:25:56.683093
178	22	7	::1	\N	\N	2026-01-05 20:25:56.683832
179	15	7	::1	\N	\N	2026-01-05 20:25:56.78933
180	15	7	::1	\N	\N	2026-01-05 20:25:56.824329
181	23	7	::1	\N	\N	2026-01-05 20:30:13.203884
182	1	7	::1	\N	\N	2026-01-05 20:30:13.205266
183	15	7	::1	\N	\N	2026-01-05 20:30:13.210631
184	23	7	::1	\N	\N	2026-01-05 20:30:13.230562
185	1	7	::1	\N	\N	2026-01-05 20:30:13.232877
186	15	7	::1	\N	\N	2026-01-05 20:30:13.233911
187	22	7	::1	\N	\N	2026-01-05 20:30:13.277995
188	22	7	::1	\N	\N	2026-01-05 20:30:13.291028
189	23	34	::1	\N	\N	2026-01-05 20:30:30.126345
190	22	34	::1	\N	\N	2026-01-05 20:30:30.129956
191	1	34	::1	\N	\N	2026-01-05 20:30:30.130779
192	23	34	::1	\N	\N	2026-01-05 20:30:30.14912
193	1	34	::1	\N	\N	2026-01-05 20:30:30.149355
194	22	34	::1	\N	\N	2026-01-05 20:30:30.149556
195	15	34	::1	\N	\N	2026-01-05 20:30:30.227594
196	15	34	::1	\N	\N	2026-01-05 20:30:30.234905
197	23	34	::1	\N	\N	2026-01-05 20:30:42.313841
198	23	34	::1	\N	\N	2026-01-05 20:30:42.321721
199	15	34	::1	\N	\N	2026-01-05 20:33:20.033907
200	15	34	::1	\N	\N	2026-01-05 20:33:20.040957
201	23	34	::1	\N	\N	2026-01-05 20:36:28.203515
202	23	34	::1	\N	\N	2026-01-05 20:36:28.218144
203	23	8	::1	\N	\N	2026-01-05 20:47:17.689723
204	22	8	::1	\N	\N	2026-01-05 20:47:17.69025
205	15	8	::1	\N	\N	2026-01-05 20:47:17.690506
206	22	8	::1	\N	\N	2026-01-05 20:47:17.705485
207	23	8	::1	\N	\N	2026-01-05 20:47:17.705707
208	15	8	::1	\N	\N	2026-01-05 20:47:17.705844
209	1	8	::1	\N	\N	2026-01-05 20:47:17.846813
210	1	8	::1	\N	\N	2026-01-05 20:47:17.864391
211	23	8	::1	\N	\N	2026-01-05 20:55:18.411105
212	22	8	::1	\N	\N	2026-01-05 20:55:18.412496
213	15	8	::1	\N	\N	2026-01-05 20:55:18.41373
215	23	8	::1	\N	\N	2026-01-05 20:55:18.431104
214	1	8	::1	\N	\N	2026-01-05 20:55:18.429015
216	22	8	::1	\N	\N	2026-01-05 20:55:18.431494
217	15	8	::1	\N	\N	2026-01-05 20:55:18.432285
218	1	8	::1	\N	\N	2026-01-05 20:55:18.453601
219	22	8	::1	\N	\N	2026-01-05 20:56:32.890634
221	1	8	::1	\N	\N	2026-01-05 20:56:32.891639
220	15	8	::1	\N	\N	2026-01-05 20:56:32.891154
222	23	8	::1	\N	\N	2026-01-05 20:56:32.895054
223	22	8	::1	\N	\N	2026-01-05 20:56:32.913984
224	1	8	::1	\N	\N	2026-01-05 20:56:32.916511
225	15	8	::1	\N	\N	2026-01-05 20:56:32.917203
226	23	8	::1	\N	\N	2026-01-05 20:56:32.917652
227	23	7	::1	\N	\N	2026-01-05 20:56:47.827913
229	22	7	::1	\N	\N	2026-01-05 20:56:47.828331
228	15	7	::1	\N	\N	2026-01-05 20:56:47.828163
230	23	7	::1	\N	\N	2026-01-05 20:56:47.84688
231	22	7	::1	\N	\N	2026-01-05 20:56:47.847126
232	15	7	::1	\N	\N	2026-01-05 20:56:47.847285
233	1	7	::1	\N	\N	2026-01-05 20:56:47.977333
234	1	7	::1	\N	\N	2026-01-05 20:56:47.985573
235	23	7	::1	\N	\N	2026-01-05 20:57:23.728777
236	15	7	::1	\N	\N	2026-01-05 20:57:23.729363
237	23	7	::1	\N	\N	2026-01-05 20:57:23.745258
238	15	7	::1	\N	\N	2026-01-05 20:57:23.745546
239	22	7	::1	\N	\N	2026-01-05 20:57:23.770003
240	22	7	::1	\N	\N	2026-01-05 20:57:23.781321
241	1	7	::1	\N	\N	2026-01-05 20:57:23.870577
242	1	7	::1	\N	\N	2026-01-05 20:57:23.887292
243	23	7	::1	\N	\N	2026-01-05 21:07:18.631866
244	15	7	::1	\N	\N	2026-01-05 21:07:18.633413
245	22	7	::1	\N	\N	2026-01-05 21:07:18.633698
246	15	7	::1	\N	\N	2026-01-05 21:07:18.646585
247	23	7	::1	\N	\N	2026-01-05 21:07:18.646741
248	22	7	::1	\N	\N	2026-01-05 21:07:18.646857
249	1	7	::1	\N	\N	2026-01-05 21:07:18.677339
250	1	7	::1	\N	\N	2026-01-05 21:07:18.687139
251	23	7	::1	\N	\N	2026-01-05 21:08:05.886604
252	15	7	::1	\N	\N	2026-01-05 21:08:05.88686
253	22	7	::1	\N	\N	2026-01-05 21:08:05.888865
254	23	7	::1	\N	\N	2026-01-05 21:08:05.912964
255	15	7	::1	\N	\N	2026-01-05 21:08:05.913136
256	22	7	::1	\N	\N	2026-01-05 21:08:05.913246
257	1	7	::1	\N	\N	2026-01-05 21:08:05.945598
258	1	7	::1	\N	\N	2026-01-05 21:08:05.956906
259	23	34	::1	\N	\N	2026-01-05 21:08:35.539582
260	22	34	::1	\N	\N	2026-01-05 21:08:35.540184
261	15	34	::1	\N	\N	2026-01-05 21:08:35.540336
262	23	34	::1	\N	\N	2026-01-05 21:08:35.550273
263	15	34	::1	\N	\N	2026-01-05 21:08:35.550384
264	22	34	::1	\N	\N	2026-01-05 21:08:35.550514
265	1	34	::1	\N	\N	2026-01-05 21:08:35.581454
266	1	34	::1	\N	\N	2026-01-05 21:08:35.597152
267	23	34	::1	\N	\N	2026-01-05 21:08:47.187658
269	15	34	::1	\N	\N	2026-01-05 21:08:47.188329
268	22	34	::1	\N	\N	2026-01-05 21:08:47.188133
270	23	34	::1	\N	\N	2026-01-05 21:08:47.207537
271	22	34	::1	\N	\N	2026-01-05 21:08:47.209215
272	15	34	::1	\N	\N	2026-01-05 21:08:47.210424
273	1	34	::1	\N	\N	2026-01-05 21:08:47.247026
274	1	34	::1	\N	\N	2026-01-05 21:08:47.256883
275	1	34	::1	\N	\N	2026-01-05 21:09:03.65233
277	15	34	::1	\N	\N	2026-01-05 21:09:03.652439
278	22	34	::1	\N	\N	2026-01-05 21:09:03.65255
276	23	34	::1	\N	\N	2026-01-05 21:09:03.652037
279	1	34	::1	\N	\N	2026-01-05 21:09:03.675067
280	15	34	::1	\N	\N	2026-01-05 21:09:03.675517
281	22	34	::1	\N	\N	2026-01-05 21:09:03.676252
282	23	34	::1	\N	\N	2026-01-05 21:09:03.67747
283	23	7	::1	\N	\N	2026-01-05 21:38:19.81191
284	23	7	::1	\N	\N	2026-01-05 21:38:19.818242
285	23	7	::1	\N	\N	2026-01-05 22:17:39.859837
286	22	7	::1	\N	\N	2026-01-05 22:17:39.860258
287	15	7	::1	\N	\N	2026-01-05 22:17:39.86076
288	23	7	::1	\N	\N	2026-01-05 22:17:39.877923
289	15	7	::1	\N	\N	2026-01-05 22:17:39.878637
290	22	7	::1	\N	\N	2026-01-05 22:17:39.878644
291	1	7	::1	\N	\N	2026-01-05 22:17:39.909206
292	1	7	::1	\N	\N	2026-01-05 22:17:39.922147
293	15	7	::1	\N	\N	2026-01-05 22:17:52.859555
294	23	7	::1	\N	\N	2026-01-05 22:17:52.86855
295	15	7	::1	\N	\N	2026-01-05 22:17:52.872003
296	23	7	::1	\N	\N	2026-01-05 22:17:52.878869
297	22	7	::1	\N	\N	2026-01-05 22:17:52.914047
299	22	7	::1	\N	\N	2026-01-05 22:17:52.921526
298	1	7	::1	\N	\N	2026-01-05 22:17:52.92129
300	1	7	::1	\N	\N	2026-01-05 22:17:52.934059
301	1	7	::1	\N	\N	2026-01-06 02:06:44.313752
303	15	7	::1	\N	\N	2026-01-06 02:06:44.314163
302	23	7	::1	\N	\N	2026-01-06 02:06:44.314003
304	15	7	::1	\N	\N	2026-01-06 02:06:44.331687
305	1	7	::1	\N	\N	2026-01-06 02:06:44.331863
306	23	7	::1	\N	\N	2026-01-06 02:06:44.332043
307	22	7	::1	\N	\N	2026-01-06 02:06:44.351597
308	22	7	::1	\N	\N	2026-01-06 02:06:44.361564
309	23	7	::1	\N	\N	2026-01-06 02:16:53.356455
310	15	7	::1	\N	\N	2026-01-06 02:16:53.357834
311	22	7	::1	\N	\N	2026-01-06 02:16:53.358097
312	23	7	::1	\N	\N	2026-01-06 02:16:53.371773
313	15	7	::1	\N	\N	2026-01-06 02:16:53.37194
314	22	7	::1	\N	\N	2026-01-06 02:16:53.372043
315	1	7	::1	\N	\N	2026-01-06 02:16:53.507063
316	1	7	::1	\N	\N	2026-01-06 02:16:53.521363
317	23	\N	::1	\N	\N	2026-01-06 02:24:25.769603
318	23	\N	::1	\N	\N	2026-01-06 02:24:25.775436
319	23	36	::1	\N	\N	2026-01-06 02:28:24.30199
320	15	36	::1	\N	\N	2026-01-06 02:28:24.303817
321	1	36	::1	\N	\N	2026-01-06 02:28:24.313402
322	23	36	::1	\N	\N	2026-01-06 02:28:24.316896
323	15	36	::1	\N	\N	2026-01-06 02:28:24.321571
324	1	36	::1	\N	\N	2026-01-06 02:28:24.324807
325	22	36	::1	\N	\N	2026-01-06 02:28:24.357405
326	22	36	::1	\N	\N	2026-01-06 02:28:24.373944
327	23	36	::1	\N	\N	2026-01-06 02:30:04.535302
328	23	36	::1	\N	\N	2026-01-06 02:30:04.542813
329	22	36	::1	\N	\N	2026-01-06 02:30:59.676945
330	22	36	::1	\N	\N	2026-01-06 02:30:59.684201
331	18	36	::1	\N	\N	2026-01-06 02:32:33.732602
332	18	36	::1	\N	\N	2026-01-06 02:32:33.741168
333	22	36	::1	\N	\N	2026-01-06 02:32:42.552246
334	22	36	::1	\N	\N	2026-01-06 02:32:42.558617
335	18	36	::1	\N	\N	2026-01-06 02:36:14.052762
336	18	36	::1	\N	\N	2026-01-06 02:36:14.062714
339	22	7	\N	\N	\N	2026-01-11 02:06:53.054136
337	18	7	\N	\N	\N	2026-01-11 02:06:53.054375
338	23	7	\N	\N	\N	2026-01-11 02:06:53.056312
340	15	7	\N	\N	\N	2026-01-11 02:06:53.079227
341	18	7	\N	\N	\N	2026-01-11 02:06:53.079457
342	1	7	\N	\N	\N	2026-01-11 02:06:53.080426
343	22	7	\N	\N	\N	2026-01-11 02:06:53.088827
344	23	7	\N	\N	\N	2026-01-11 02:06:53.088941
345	15	7	\N	\N	\N	2026-01-11 02:06:53.09003
346	1	7	\N	\N	\N	2026-01-11 02:06:53.097402
347	18	7	\N	\N	\N	2026-01-11 02:08:53.972408
348	23	7	\N	\N	\N	2026-01-11 02:08:53.972579
349	22	7	\N	\N	\N	2026-01-11 02:08:53.972653
350	15	7	\N	\N	\N	2026-01-11 02:08:53.991393
351	1	7	\N	\N	\N	2026-01-11 02:08:54.00123
352	18	7	\N	\N	\N	2026-01-11 02:08:54.002088
353	15	7	\N	\N	\N	2026-01-11 02:08:54.089631
354	23	7	\N	\N	\N	2026-01-11 02:08:54.089779
355	22	7	\N	\N	\N	2026-01-11 02:08:54.089827
356	1	7	\N	\N	\N	2026-01-11 02:08:54.104936
357	22	7	\N	\N	\N	2026-01-11 02:08:57.041716
358	18	7	\N	\N	\N	2026-01-11 02:08:57.04198
359	18	7	\N	\N	\N	2026-01-11 02:08:57.067766
360	22	7	\N	\N	\N	2026-01-11 02:08:57.067978
361	23	7	\N	\N	\N	2026-01-11 02:08:57.166823
362	15	7	\N	\N	\N	2026-01-11 02:08:57.167371
363	23	7	\N	\N	\N	2026-01-11 02:08:57.204299
364	15	7	\N	\N	\N	2026-01-11 02:08:57.204372
365	1	7	\N	\N	\N	2026-01-11 02:08:57.218752
366	1	7	\N	\N	\N	2026-01-11 02:08:57.225228
367	18	10	\N	\N	\N	2026-01-11 02:09:15.509023
368	22	10	\N	\N	\N	2026-01-11 02:09:15.509192
369	23	10	\N	\N	\N	2026-01-11 02:09:15.517531
370	15	10	\N	\N	\N	2026-01-11 02:09:15.517798
371	1	10	\N	\N	\N	2026-01-11 02:09:15.524306
372	22	10	\N	\N	\N	2026-01-11 02:09:15.533524
373	18	10	\N	\N	\N	2026-01-11 02:09:15.533623
374	15	10	\N	\N	\N	2026-01-11 02:09:15.538889
375	23	10	\N	\N	\N	2026-01-11 02:09:15.539415
376	1	10	\N	\N	\N	2026-01-11 02:09:15.548031
377	22	8	\N	\N	\N	2026-01-11 02:09:43.264914
378	23	8	\N	\N	\N	2026-01-11 02:09:43.265117
379	18	8	\N	\N	\N	2026-01-11 02:09:43.26518
380	15	8	\N	\N	\N	2026-01-11 02:09:43.272882
381	1	8	\N	\N	\N	2026-01-11 02:09:43.273295
382	18	8	\N	\N	\N	2026-01-11 02:09:43.282202
383	23	8	\N	\N	\N	2026-01-11 02:09:43.2825
384	22	8	\N	\N	\N	2026-01-11 02:09:43.283855
385	1	8	\N	\N	\N	2026-01-11 02:09:43.289934
386	15	8	\N	\N	\N	2026-01-11 02:09:43.29064
387	18	8	\N	\N	\N	2026-01-11 02:10:14.879211
388	18	8	\N	\N	\N	2026-01-11 02:10:14.884718
389	9	8	\N	\N	\N	2026-01-11 02:15:48.02264
390	9	8	\N	\N	\N	2026-01-11 02:15:48.03078
391	9	8	\N	\N	\N	2026-01-11 02:16:08.300137
392	9	8	\N	\N	\N	2026-01-11 02:16:08.310757
393	9	8	\N	\N	\N	2026-01-11 02:16:58.255602
394	22	8	\N	\N	\N	2026-01-11 02:16:58.259179
395	1	8	\N	\N	\N	2026-01-11 02:16:58.261277
396	15	8	\N	\N	\N	2026-01-11 02:16:58.26252
397	18	8	\N	\N	\N	2026-01-11 02:16:58.262573
398	23	8	\N	\N	\N	2026-01-11 02:16:58.270684
399	22	8	\N	\N	\N	2026-01-11 02:16:58.285643
400	15	8	\N	\N	\N	2026-01-11 02:16:58.285914
401	23	8	\N	\N	\N	2026-01-11 02:16:58.285994
402	9	8	\N	\N	\N	2026-01-11 02:16:58.286065
403	18	8	\N	\N	\N	2026-01-11 02:16:58.286077
404	1	8	\N	\N	\N	2026-01-11 02:16:58.286191
405	9	7	\N	\N	\N	2026-01-11 02:26:00.890258
406	9	7	\N	\N	\N	2026-01-11 02:26:00.898312
407	9	7	\N	\N	\N	2026-01-11 02:29:52.265538
408	18	7	\N	\N	\N	2026-01-11 02:29:52.269182
409	22	7	\N	\N	\N	2026-01-11 02:29:52.277988
410	23	7	\N	\N	\N	2026-01-11 02:29:52.283418
411	15	7	\N	\N	\N	2026-01-11 02:29:52.289703
412	1	7	\N	\N	\N	2026-01-11 02:29:52.292425
413	9	7	\N	\N	\N	2026-01-11 02:29:52.297301
414	18	7	\N	\N	\N	2026-01-11 02:29:52.299029
415	22	7	\N	\N	\N	2026-01-11 02:29:52.306429
416	23	7	\N	\N	\N	2026-01-11 02:29:52.306701
417	15	7	\N	\N	\N	2026-01-11 02:29:52.312126
418	1	7	\N	\N	\N	2026-01-11 02:29:52.31276
419	9	7	\N	\N	\N	2026-01-11 02:30:08.709552
420	18	7	\N	\N	\N	2026-01-11 02:30:08.709667
421	22	7	\N	\N	\N	2026-01-11 02:30:08.715508
422	23	7	\N	\N	\N	2026-01-11 02:30:08.715649
423	15	7	\N	\N	\N	2026-01-11 02:30:08.723158
424	1	7	\N	\N	\N	2026-01-11 02:30:08.723417
425	18	7	\N	\N	\N	2026-01-11 02:30:08.747726
426	9	7	\N	\N	\N	2026-01-11 02:30:08.747815
427	22	7	\N	\N	\N	2026-01-11 02:30:08.752205
428	23	7	\N	\N	\N	2026-01-11 02:30:08.752808
429	1	7	\N	\N	\N	2026-01-11 02:30:08.761469
430	15	7	\N	\N	\N	2026-01-11 02:30:08.761538
431	9	7	\N	\N	\N	2026-01-11 02:33:25.223221
432	18	7	\N	\N	\N	2026-01-11 02:33:25.228145
433	22	7	\N	\N	\N	2026-01-11 02:33:25.233822
434	23	7	\N	\N	\N	2026-01-11 02:33:25.239659
435	15	7	\N	\N	\N	2026-01-11 02:33:25.244048
436	1	7	\N	\N	\N	2026-01-11 02:33:25.247602
437	9	7	\N	\N	\N	2026-01-11 02:33:25.263978
438	18	7	\N	\N	\N	2026-01-11 02:33:25.269973
439	22	7	\N	\N	\N	2026-01-11 02:33:25.273843
440	23	7	\N	\N	\N	2026-01-11 02:33:25.276988
441	15	7	\N	\N	\N	2026-01-11 02:33:25.280506
442	1	7	\N	\N	\N	2026-01-11 02:33:25.286526
443	9	7	\N	\N	\N	2026-01-11 03:01:38.529489
444	18	7	\N	\N	\N	2026-01-11 03:01:38.530282
445	22	7	\N	\N	\N	2026-01-11 03:01:38.544005
446	23	7	\N	\N	\N	2026-01-11 03:01:38.544359
447	15	7	\N	\N	\N	2026-01-11 03:01:38.552981
448	9	7	\N	\N	\N	2026-01-11 03:01:38.553608
449	18	7	\N	\N	\N	2026-01-11 03:01:38.563165
450	1	7	\N	\N	\N	2026-01-11 03:01:38.563621
451	23	7	\N	\N	\N	2026-01-11 03:01:38.572749
452	22	7	\N	\N	\N	2026-01-11 03:01:38.573135
453	1	7	\N	\N	\N	2026-01-11 03:01:38.580503
454	15	7	\N	\N	\N	2026-01-11 03:01:38.580508
455	63	40	\N	\N	\N	2026-02-05 20:58:20.155605
456	63	40	\N	\N	\N	2026-02-05 20:58:20.175068
457	63	40	\N	\N	\N	2026-02-05 21:10:09.228886
458	63	40	\N	\N	\N	2026-02-05 21:10:09.240519
459	63	40	\N	\N	\N	2026-02-05 21:15:44.286493
460	63	40	\N	\N	\N	2026-02-05 21:15:44.29756
461	63	7	\N	\N	\N	2026-02-06 00:52:05.953084
462	63	7	\N	\N	\N	2026-02-06 00:52:05.967224
463	63	7	\N	\N	\N	2026-02-09 23:01:38.783388
464	63	7	\N	\N	\N	2026-02-09 23:01:38.830641
465	63	7	\N	\N	\N	2026-02-10 00:13:29.182294
466	63	7	\N	\N	\N	2026-02-10 00:13:29.194644
467	63	7	\N	\N	\N	2026-02-10 00:17:51.615009
468	63	7	\N	\N	\N	2026-02-10 00:17:51.6382
469	63	7	\N	\N	\N	2026-02-10 00:45:41.026454
470	63	7	\N	\N	\N	2026-02-10 00:45:41.07296
471	37	7	\N	\N	\N	2026-02-10 00:48:15.772086
472	37	7	\N	\N	\N	2026-02-10 00:48:15.784871
473	37	7	\N	\N	\N	2026-02-10 01:01:08.360139
474	54	8	\N	\N	\N	2026-02-10 01:07:54.807097
475	23	7	\N	\N	\N	2026-02-10 01:44:51.57185
476	23	7	\N	\N	\N	2026-02-10 01:44:51.579042
477	37	7	\N	\N	\N	2026-02-10 01:47:08.227856
478	37	7	\N	\N	\N	2026-02-10 01:47:08.240362
479	40	7	\N	\N	\N	2026-02-10 02:04:55.642977
480	40	7	\N	\N	\N	2026-02-10 02:04:55.653976
481	37	7	\N	\N	\N	2026-02-10 02:19:16.528671
482	37	7	\N	\N	\N	2026-02-10 02:19:16.537822
483	37	7	\N	\N	\N	2026-02-10 02:24:44.701685
484	37	7	\N	\N	\N	2026-02-10 02:24:44.712298
\.


--
-- Data for Name: price_alerts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_alerts (id, user_id, boat_id, original_price, target_price, alert_on_any_drop, is_active, last_notified_at, created_at) FROM stdin;
\.


--
-- Data for Name: price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_history (id, boat_id, old_price, new_price, changed_at) FROM stdin;
\.


--
-- Data for Name: saved_searches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.saved_searches (id, user_id, name, filters, notify_new_listings, notify_price_drops, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, full_name, phone, role, created_at, updated_at, first_name, last_name, is_active, avatar_url, email_verified, email_verification_token, password_reset_token, password_reset_expires, last_login, deleted_at, is_support_admin) FROM stdin;
1	scraped_seller	scraped-seller@yachtx.com	$2b$10$EfjonsC68vIgJ9kR4ReYN.D5UttXB6q56ZTAbGEHKUvDYWhO5vAmK	\N	\N	seller	2026-01-04 18:22:03.542068	2026-01-04 18:22:03.542068	\N	\N	t	\N	f	\N	\N	\N	\N	\N	f
6	financeuser1767544170508	finance1767544170508@yachtx.com	$2a$10$jLwVaweEplwlrW4hl3rdouhCl2dwLasqpWDjVOrl/CM5UPRoPgRt6	\N	\N	finance	2026-01-04 21:59:30.593588	2026-01-04 21:59:30.593588	Finance	Agent	t	\N	f	\N	\N	\N	\N	\N	f
12	esha	esha@gmai.com	$2a$10$oGDS/4ROKf9ZTEO98.E9SeupJfqKe/oJFVzVisHBpzWdbBhkQr7vW	\N		buyer	2026-01-05 01:16:57.228689	2026-01-05 01:16:57.228689	esha		t	\N	f	\N	\N	\N	\N	\N	f
14	sarahseller	seller4@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-678-9012	seller	2025-12-26 03:02:40.85806	2026-01-05 20:45:49.22638	Sarah	Davis	t	\N	t	\N	\N	\N	2026-02-04 18:00:24.407432	\N	f
34	Robert	robert@gmail.com	$2a$10$9wr9POxGTLTE.dO3K1jfvecSKk9zcfmiaRjufzcFeYDWb0ejaK0dS	\N		seller	2026-01-05 19:28:54.656829	2026-01-05 19:28:54.656829			t	\N	f	\N	\N	\N	2026-01-05 21:09:03.225222	\N	f
16	alicebuyer	buyer2@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-890-1234	buyer	2025-12-16 03:02:40.85806	2026-01-05 20:45:49.22638	Alice	Martinez	t	\N	t	\N	\N	\N	2026-02-04 18:00:31.070578	\N	f
17	charliebuyer	buyer3@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-901-2345	buyer	2025-12-28 03:02:40.85806	2026-01-05 20:45:49.22638	Charlie	Anderson	t	\N	t	\N	\N	\N	2026-02-04 18:00:33.355795	\N	f
35	chris	chris@gmail.com	$2a$10$WVcivrbgNX4VYXS.Db10pOjItfPO.uhr7fr4LUfH2rm8fVHa2qrk6	\N		buyer	2026-01-05 19:30:34.971545	2026-01-05 19:30:34.971545			t	\N	f	\N	\N	\N	2026-01-05 19:30:54.836385	\N	f
8	johnseller	seller@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-123-4567	seller	2026-01-05 01:07:28.798586	2026-01-05 20:45:49.22638	John	Smith	t	\N	t	\N	\N	\N	2026-02-10 01:18:06.480174	\N	f
10	bobbuyer	buyer@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-345-6789	buyer	2026-01-05 01:07:28.798586	2026-01-05 20:45:49.22638	Bob	Williams	t	\N	t	\N	\N	\N	2026-02-10 00:45:24.694866	\N	f
15	mikeseller	seller5@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-789-0123	seller	2025-12-31 03:02:40.85806	2026-01-05 20:45:49.22638	Mike	Wilson	f	\N	t	\N	\N	\N	\N	\N	f
18	dianabuyer	buyer4@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-012-3456	buyer	2026-01-02 03:02:40.85806	2026-01-05 20:45:49.22638	Diana	Taylor	f	\N	t	\N	\N	\N	\N	\N	f
19	admin2	admin2@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-111-2222	admin	2025-12-11 03:02:40.85806	2026-01-05 20:45:49.22638	Secondary	Admin	t	\N	t	\N	\N	\N	2026-02-04 18:00:15.19213	\N	f
9	maryseller	seller2@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-234-5678	seller	2026-01-05 01:07:28.798586	2026-01-05 20:45:49.22638	Mary	Johnson	t	\N	t	\N	\N	\N	2026-02-04 18:00:19.812516	\N	f
13	davidseller	seller3@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	555-567-8901	seller	2025-12-21 03:02:40.85806	2026-01-05 20:45:49.22638	David	Brown	t	\N	t	\N	\N	\N	2026-02-04 18:00:22.113302	\N	f
36	eshaas	esha@hmail.com	$2a$10$plIfO4qu6mEOB8XHVKGXbu1CzyCxLfeyHwBVaMw6YKQh1bkr/6X.i	\N		seller	2026-01-06 02:28:23.851952	2026-01-06 02:28:23.851952			t	\N	f	\N	\N	\N	\N	\N	f
7	admin	admin@yachtx.com	$2a$12$YfP4q8zQ485s3jKl6K3LD.A0XkTo.9aObL2pu.ixfhudXDOpMfrzG	\N	443-888-9190	admin	2026-01-05 01:07:28.798586	2026-01-05 20:45:49.22638	Admin	User	t	\N	t	\N	\N	\N	2026-02-10 02:24:35.096147	\N	f
37	tom	tom@yachx.com	$2b$12$h5KwweJoLpdduJxW826cDOM08igKkozhGVtuNSJAFL4ea0CduXkUO	\N	1234567890	buyer	2026-02-05 19:15:04.558406	2026-02-05 19:15:04.558406	tom	evans	t	\N	f	\N	\N	\N	\N	\N	f
38	seller9	seller9@yachx.com	$2b$12$lf0bjeYvw4SaTknRlJZzOOZ98.d1VkHT0PqleghMKEpP19hE0uMDy	\N	0987654321	seller	2026-02-05 19:17:05.766141	2026-02-05 19:40:58.004358	seller	relles	t	\N	f	\N	\N	\N	\N	\N	f
39	billseller	bill@yachx.com	$2b$12$ASwnRgdvRdfJBl17VmkIcOwijMPs0aAS95hAFZags62A41S/pcgS6	\N	1234567899	seller	2026-02-05 20:24:33.561544	2026-02-05 20:24:33.561544	bill		t	\N	f	\N	\N	\N	\N	\N	f
40	lescinq_holdings	lescinq@yachtx.com	$2b$10$IuFoTaz7FGhzMNgIRKnVVOg1YGsTZG2cSJwGAIrK0PmwVHIruFELC	\N	+377 99 99 99 99	seller	2026-02-05 20:50:33.70092	2026-02-05 20:50:33.70092	Les Cinq	Holdings	t	\N	t	\N	\N	\N	2026-02-05 20:54:48.496504	\N	f
\.


--
-- Name: admin_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_notifications_id_seq', 165, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_id_seq', 4, true);


--
-- Name: boat_comparisons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boat_comparisons_id_seq', 1, false);


--
-- Name: boat_equipment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boat_equipment_id_seq', 1, false);


--
-- Name: boat_photos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boat_photos_id_seq', 1, false);


--
-- Name: boat_restricted_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boat_restricted_id_seq', 1, true);


--
-- Name: boat_specifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boat_specifications_id_seq', 16, true);


--
-- Name: boats_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.boats_id_seq', 87, true);


--
-- Name: contact_admin_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_admin_notes_id_seq', 7, true);


--
-- Name: contact_submissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_submissions_id_seq', 21, true);


--
-- Name: deal_admin_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deal_admin_notes_id_seq', 83, true);


--
-- Name: deals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deals_id_seq', 53, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorites_id_seq', 43, true);


--
-- Name: images_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.images_id_seq', 43, true);


--
-- Name: inquiries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inquiries_id_seq', 143, true);


--
-- Name: inquiry_admin_notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inquiry_admin_notes_id_seq', 7, true);


--
-- Name: inquiry_tags_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inquiry_tags_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_id_seq', 1863, true);


--
-- Name: page_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.page_views_id_seq', 484, true);


--
-- Name: price_alerts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_alerts_id_seq', 1, false);


--
-- Name: price_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.price_history_id_seq', 1, false);


--
-- Name: saved_searches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.saved_searches_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 69, true);


--
-- Name: admin_notifications admin_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_notifications
    ADD CONSTRAINT admin_notifications_pkey PRIMARY KEY (id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);


--
-- Name: boat_comparisons boat_comparisons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_comparisons
    ADD CONSTRAINT boat_comparisons_pkey PRIMARY KEY (id);


--
-- Name: boat_equipment boat_equipment_boat_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_equipment
    ADD CONSTRAINT boat_equipment_boat_id_key UNIQUE (boat_id);


--
-- Name: boat_equipment boat_equipment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_equipment
    ADD CONSTRAINT boat_equipment_pkey PRIMARY KEY (id);


--
-- Name: boat_photos boat_photos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_photos
    ADD CONSTRAINT boat_photos_pkey PRIMARY KEY (id);


--
-- Name: boat_restricted boat_restricted_boat_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_restricted
    ADD CONSTRAINT boat_restricted_boat_id_key UNIQUE (boat_id);


--
-- Name: boat_restricted boat_restricted_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_restricted
    ADD CONSTRAINT boat_restricted_pkey PRIMARY KEY (id);


--
-- Name: boat_specifications boat_specifications_boat_id_category_spec_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_specifications
    ADD CONSTRAINT boat_specifications_boat_id_category_spec_key_key UNIQUE (boat_id, category, spec_key);


--
-- Name: boat_specifications boat_specifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_specifications
    ADD CONSTRAINT boat_specifications_pkey PRIMARY KEY (id);


--
-- Name: boats boats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_pkey PRIMARY KEY (id);


--
-- Name: boats boats_yachtx_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_yachtx_id_key UNIQUE (yachtx_id);


--
-- Name: contact_admin_notes contact_admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_admin_notes
    ADD CONSTRAINT contact_admin_notes_pkey PRIMARY KEY (id);


--
-- Name: contact_submissions contact_submissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_submissions
    ADD CONSTRAINT contact_submissions_pkey PRIMARY KEY (id);


--
-- Name: deal_admin_notes deal_admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal_admin_notes
    ADD CONSTRAINT deal_admin_notes_pkey PRIMARY KEY (id);


--
-- Name: deals deals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_user_id_boat_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_boat_id_key UNIQUE (user_id, boat_id);


--
-- Name: boat_images images_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: inquiries inquiries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_pkey PRIMARY KEY (id);


--
-- Name: inquiry_admin_notes inquiry_admin_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_admin_notes
    ADD CONSTRAINT inquiry_admin_notes_pkey PRIMARY KEY (id);


--
-- Name: inquiry_tags inquiry_tags_inquiry_id_tag_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_tags
    ADD CONSTRAINT inquiry_tags_inquiry_id_tag_key UNIQUE (inquiry_id, tag);


--
-- Name: inquiry_tags inquiry_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_tags
    ADD CONSTRAINT inquiry_tags_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: page_views page_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_pkey PRIMARY KEY (id);


--
-- Name: price_alerts price_alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_pkey PRIMARY KEY (id);


--
-- Name: price_alerts price_alerts_user_id_boat_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_user_id_boat_id_key UNIQUE (user_id, boat_id);


--
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (id);


--
-- Name: saved_searches saved_searches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_admin_notifications_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_admin_notifications_entity ON public.admin_notifications USING btree (entity_type, entity_id);


--
-- Name: idx_admin_notifications_unread; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_admin_notifications_unread ON public.admin_notifications USING btree (is_read, created_at DESC);


--
-- Name: idx_audit_logs_admin_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_admin_id ON public.audit_logs USING btree (admin_id);


--
-- Name: idx_audit_logs_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_created_at ON public.audit_logs USING btree (created_at);


--
-- Name: idx_audit_logs_entity; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_logs_entity ON public.audit_logs USING btree (entity_type, entity_id);


--
-- Name: idx_boat_equipment_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_equipment_boat_id ON public.boat_equipment USING btree (boat_id);


--
-- Name: idx_boat_images_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_images_boat_id ON public.boat_images USING btree (boat_id);


--
-- Name: idx_boat_photos_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_photos_boat_id ON public.boat_photos USING btree (boat_id);


--
-- Name: idx_boat_photos_group; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_photos_group ON public.boat_photos USING btree (boat_id, group_key);


--
-- Name: idx_boat_photos_primary; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_boat_photos_primary ON public.boat_photos USING btree (boat_id) WHERE (is_primary = true);


--
-- Name: idx_boat_restricted_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_restricted_boat_id ON public.boat_restricted USING btree (boat_id);


--
-- Name: idx_boat_restricted_boat_id_lookup; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boat_restricted_boat_id_lookup ON public.boat_restricted USING btree (boat_id);


--
-- Name: idx_boats_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_deleted_at ON public.boats USING btree (deleted_at);


--
-- Name: idx_boats_featured; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_featured ON public.boats USING btree (featured);


--
-- Name: idx_boats_length; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_length ON public.boats USING btree (length_ft);


--
-- Name: idx_boats_make; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_make ON public.boats USING btree (make);


--
-- Name: idx_boats_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_price ON public.boats USING btree (asking_price);


--
-- Name: idx_boats_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_status ON public.boats USING btree (status);


--
-- Name: idx_boats_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_user_id ON public.boats USING btree (user_id);


--
-- Name: idx_boats_year; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_boats_year ON public.boats USING btree (year);


--
-- Name: idx_contact_assigned_to; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_assigned_to ON public.contact_submissions USING btree (assigned_to);


--
-- Name: idx_contact_notes_contact_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_notes_contact_id ON public.contact_admin_notes USING btree (contact_submission_id);


--
-- Name: idx_contact_priority; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contact_priority ON public.contact_submissions USING btree (priority);


--
-- Name: idx_deal_admin_notes_deal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deal_admin_notes_deal_id ON public.deal_admin_notes USING btree (deal_id);


--
-- Name: idx_deals_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_boat_id ON public.deals USING btree (boat_id);


--
-- Name: idx_deals_buyer_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_buyer_id ON public.deals USING btree (buyer_id);


--
-- Name: idx_deals_seller_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_seller_id ON public.deals USING btree (seller_id);


--
-- Name: idx_deals_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deals_status ON public.deals USING btree (status);


--
-- Name: idx_deals_unique_active; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_deals_unique_active ON public.deals USING btree (boat_id, buyer_id) WHERE ((buyer_id IS NOT NULL) AND ((status)::text = ANY ((ARRAY['initiated'::character varying, 'in_discussion'::character varying])::text[])));


--
-- Name: idx_favorites_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_favorites_boat_id ON public.favorites USING btree (boat_id);


--
-- Name: idx_favorites_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_favorites_user_id ON public.favorites USING btree (user_id);


--
-- Name: idx_images_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_images_boat_id ON public.boat_images USING btree (boat_id);


--
-- Name: idx_inquiries_boat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiries_boat_id ON public.inquiries USING btree (boat_id);


--
-- Name: idx_inquiries_deal_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiries_deal_id ON public.inquiries USING btree (deal_id);


--
-- Name: idx_inquiries_receiver_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiries_receiver_id ON public.inquiries USING btree (receiver_id);


--
-- Name: idx_inquiries_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiries_user_id ON public.inquiries USING btree (user_id);


--
-- Name: idx_inquiry_notes_inquiry_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiry_notes_inquiry_id ON public.inquiry_admin_notes USING btree (inquiry_id);


--
-- Name: idx_inquiry_tags_inquiry_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiry_tags_inquiry_id ON public.inquiry_tags USING btree (inquiry_id);


--
-- Name: idx_inquiry_tags_tag; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inquiry_tags_tag ON public.inquiry_tags USING btree (tag);


--
-- Name: idx_users_deleted_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_deleted_at ON public.users USING btree (deleted_at);


--
-- Name: idx_users_support_admin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_support_admin ON public.users USING btree (is_support_admin) WHERE (is_support_admin = true);


--
-- Name: audit_logs audit_logs_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: boat_comparisons boat_comparisons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_comparisons
    ADD CONSTRAINT boat_comparisons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: boat_equipment boat_equipment_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_equipment
    ADD CONSTRAINT boat_equipment_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: boat_photos boat_photos_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_photos
    ADD CONSTRAINT boat_photos_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: boat_restricted boat_restricted_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_restricted
    ADD CONSTRAINT boat_restricted_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: boat_specifications boat_specifications_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_specifications
    ADD CONSTRAINT boat_specifications_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: boats boats_status_changed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_status_changed_by_fkey FOREIGN KEY (status_changed_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: boats boats_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boats
    ADD CONSTRAINT boats_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: contact_admin_notes contact_admin_notes_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_admin_notes
    ADD CONSTRAINT contact_admin_notes_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: contact_admin_notes contact_admin_notes_contact_submission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_admin_notes
    ADD CONSTRAINT contact_admin_notes_contact_submission_id_fkey FOREIGN KEY (contact_submission_id) REFERENCES public.contact_submissions(id) ON DELETE CASCADE;


--
-- Name: contact_submissions contact_submissions_assigned_to_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact_submissions
    ADD CONSTRAINT contact_submissions_assigned_to_fkey FOREIGN KEY (assigned_to) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: deal_admin_notes deal_admin_notes_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal_admin_notes
    ADD CONSTRAINT deal_admin_notes_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: deal_admin_notes deal_admin_notes_deal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deal_admin_notes
    ADD CONSTRAINT deal_admin_notes_deal_id_fkey FOREIGN KEY (deal_id) REFERENCES public.deals(id) ON DELETE CASCADE;


--
-- Name: deals deals_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: deals deals_buyer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: deals deals_seller_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: favorites favorites_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: boat_images images_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.boat_images
    ADD CONSTRAINT images_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: inquiries inquiries_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: inquiries inquiries_deal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_deal_id_fkey FOREIGN KEY (deal_id) REFERENCES public.deals(id) ON DELETE SET NULL;


--
-- Name: inquiries inquiries_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inquiries inquiries_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inquiries inquiries_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiries
    ADD CONSTRAINT inquiries_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inquiry_admin_notes inquiry_admin_notes_admin_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_admin_notes
    ADD CONSTRAINT inquiry_admin_notes_admin_id_fkey FOREIGN KEY (admin_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inquiry_admin_notes inquiry_admin_notes_inquiry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_admin_notes
    ADD CONSTRAINT inquiry_admin_notes_inquiry_id_fkey FOREIGN KEY (inquiry_id) REFERENCES public.inquiries(id) ON DELETE CASCADE;


--
-- Name: inquiry_tags inquiry_tags_inquiry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inquiry_tags
    ADD CONSTRAINT inquiry_tags_inquiry_id_fkey FOREIGN KEY (inquiry_id) REFERENCES public.inquiries(id) ON DELETE CASCADE;


--
-- Name: messages messages_inquiry_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_inquiry_id_fkey FOREIGN KEY (inquiry_id) REFERENCES public.inquiries(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: page_views page_views_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: page_views page_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.page_views
    ADD CONSTRAINT page_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: price_alerts price_alerts_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: price_alerts price_alerts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_alerts
    ADD CONSTRAINT price_alerts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: price_history price_history_boat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_boat_id_fkey FOREIGN KEY (boat_id) REFERENCES public.boats(id) ON DELETE CASCADE;


--
-- Name: saved_searches saved_searches_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_searches
    ADD CONSTRAINT saved_searches_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict f654iOrOTSkxLVhrazakYMbmonbU8eXreZagN12jxU21ihcg44c4jIYDeVkzqBh

